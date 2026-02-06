#!/usr/bin/env python3
"""
Export customized Alma letters and components via the Configuration API.

Downloads XSL templates for letters and components that have been modified
from their defaults (identified by having an update_date).
"""

import os
import sys
from pathlib import Path

import requests
from dotenv import load_dotenv

BASE_URL = "https://api-na.hosted.exlibrisgroup.com/almaws/v1"

# Output directories (relative to current working directory)
LETTERS_DIR = Path("letters")
COMPONENTS_DIR = Path("components")

# Will be set in main()
API_KEY = None


def get_headers():
    """Return headers for API requests."""
    return {
        "Authorization": f"apikey {API_KEY}",
        "Accept": "application/json",
    }


def fetch_letter_list(letter_type="LETTER"):
    """
    Fetch the list of all letters or components.

    Args:
        letter_type: "LETTER" or "COMPONENT"

    Returns:
        List of letter objects from the API response.
    """
    url = f"{BASE_URL}/conf/letters"
    params = {"type": letter_type}

    response = requests.get(url, headers=get_headers(), params=params)
    response.raise_for_status()

    data = response.json()
    return data.get("letter", [])


def fetch_letter_detail(letter_code):
    """
    Fetch the full details of a specific letter, including XSL content.

    Args:
        letter_code: The unique code identifying the letter.

    Returns:
        Letter object with XSL content.
    """
    url = f"{BASE_URL}/conf/letters/{letter_code}"

    response = requests.get(url, headers=get_headers())
    response.raise_for_status()

    return response.json()


def load_letter_list(filename):
    """
    Load letter codes from a text file.

    Lines starting with # are comments. Empty lines are ignored.
    """
    list_path = Path.cwd() / filename
    if not list_path.exists():
        return None

    codes = []
    for line in list_path.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            codes.append(line)
    return codes


def filter_customized(letters, letter_type="LETTER"):
    """
    Filter to only letters that should be exported.

    If a letters.txt (or components.txt) file exists, use that explicit list.
    Otherwise, fall back to enabled + customized filter.
    """
    # Check for explicit list file
    list_file = "letters.txt" if letter_type == "LETTER" else "components.txt"
    explicit_codes = load_letter_list(list_file)

    if explicit_codes:
        # Use explicit list
        # For components, API returns codes with .xsl (e.g., "footer.xsl")
        # but config file may have just "footer", so check both
        code_set = set(explicit_codes)
        code_set_with_xsl = {f"{c}.xsl" for c in explicit_codes}
        return [l for l in letters if l.get("code") in code_set or l.get("code") in code_set_with_xsl]

    # Fall back to enabled + customized filter
    result = []
    for letter in letters:
        enabled = letter.get("enabled", {})
        customized = letter.get("customized", {})

        is_enabled = enabled.get("value") == "true" if isinstance(enabled, dict) else enabled == "true"
        is_customized = customized.get("value") == "true" if isinstance(customized, dict) else customized == "true"

        if is_enabled and is_customized:
            result.append(letter)

    return result


def save_xsl(letter_code, xsl_content, output_dir):
    """
    Save XSL content to a file.

    Args:
        letter_code: Used as the filename (without extension).
        xsl_content: The XSL template content.
        output_dir: Directory to save the file in.
    """
    output_dir.mkdir(parents=True, exist_ok=True)
    # Avoid double .xsl extension for components
    filename = letter_code if letter_code.endswith(".xsl") else f"{letter_code}.xsl"
    output_path = output_dir / filename
    output_path.write_text(xsl_content, encoding="utf-8")
    return output_path


def export_letters(letter_type, output_dir):
    """
    Export all customized letters/components of the given type.

    Args:
        letter_type: "LETTER" or "COMPONENT"
        output_dir: Directory to save XSL files.

    Returns:
        List of exported letter codes.
    """
    print(f"\nFetching {letter_type.lower()} list...")
    all_letters = fetch_letter_list(letter_type)
    print(f"  Found {len(all_letters)} total {letter_type.lower()}s")

    customized = filter_customized(all_letters, letter_type)

    # Deduplicate by code (API may return same letter multiple times)
    seen = set()
    unique = []
    for letter in customized:
        code = letter.get("code")
        if code not in seen:
            seen.add(code)
            unique.append(letter)
    customized = unique

    print(f"  {len(customized)} to export")

    exported = []
    for letter in customized:
        code = letter["code"]
        name = letter.get("name", code)

        print(f"  Downloading: {code} ({name})")
        detail = fetch_letter_detail(code)

        xsl_content = detail.get("xsl")
        if xsl_content:
            save_xsl(code, xsl_content, output_dir)
            exported.append(code)
        else:
            print(f"    Warning: No XSL content for {code}")

    return exported


def debug_letters(letter_type="LETTER"):
    """Print details about letters to help identify filtering criteria."""
    print(f"Fetching {letter_type.lower()} list for debugging...")
    all_letters = fetch_letter_list(letter_type)

    print(f"\nTotal {letter_type.lower()}s: {len(all_letters)}")

    # For components, show all codes
    if letter_type == "COMPONENT":
        print("\nAll components:")
        for letter in all_letters:
            enabled = letter.get("enabled", {})
            customized = letter.get("customized", {})
            is_enabled = enabled.get("value") == "true" if isinstance(enabled, dict) else enabled == "true"
            is_customized = customized.get("value") == "true" if isinstance(customized, dict) else customized == "true"
            print(f"  {letter.get('code')} - {letter.get('name')} (enabled={is_enabled}, customized={is_customized})")
        return

    # Count enabled and customized
    enabled_count = 0
    customized_count = 0
    both_count = 0

    for letter in all_letters:
        enabled = letter.get("enabled", {})
        customized = letter.get("customized", {})

        is_enabled = enabled.get("value") == "true" if isinstance(enabled, dict) else enabled == "true"
        is_customized = customized.get("value") == "true" if isinstance(customized, dict) else customized == "true"

        if is_enabled:
            enabled_count += 1
        if is_customized:
            customized_count += 1
        if is_enabled and is_customized:
            both_count += 1

    print(f"  Enabled: {enabled_count}")
    print(f"  Customized: {customized_count}")
    print(f"  Both (will be exported): {both_count}")

    # Show the letters that will be exported
    filtered = filter_customized(all_letters)
    if filtered:
        print(f"\nLetters to export ({len(filtered)}):")
        print("-" * 60)
        for letter in filtered:
            print(f"  {letter.get('code')} - {letter.get('name')}")


def main():
    global API_KEY

    # Load .env from current working directory
    env_path = Path.cwd() / ".env"
    load_dotenv(env_path)
    API_KEY = os.getenv("ALMA_API_KEY")

    if not API_KEY:
        print("Error: ALMA_API_KEY environment variable not set.")
        print("Copy .env.example to .env and add your API key.")
        sys.exit(1)

    # Check for debug mode
    if len(sys.argv) > 1 and sys.argv[1] == "--debug":
        debug_letters("LETTER")
        print()
        debug_letters("COMPONENT")
        return

    print("Alma Letter Export")
    print("=" * 40)

    # Export letters
    letters = export_letters("LETTER", LETTERS_DIR)

    # Export components
    components = export_letters("COMPONENT", COMPONENTS_DIR)

    # Summary
    print("\n" + "=" * 40)
    print("Export complete!")
    print(f"  Letters exported: {len(letters)}")
    print(f"  Components exported: {len(components)}")

    if letters:
        print(f"\nLetters saved to: {LETTERS_DIR}")
    if components:
        print(f"Components saved to: {COMPONENTS_DIR}")


if __name__ == "__main__":
    main()
