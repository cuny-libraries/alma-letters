#!/usr/bin/env python3
"""
Export and push Alma letters and components via the Configuration API.

Downloads XSL templates for letters and components that have been modified
from their defaults, and can push local changes back to Alma.
"""

import os
import sys
from pathlib import Path

import requests
from dotenv import load_dotenv

# API base URLs by region
REGION_URLS = {
    "na": "https://api-na.hosted.exlibrisgroup.com",
    "eu": "https://api-eu.hosted.exlibrisgroup.com",
    "ap": "https://api-ap.hosted.exlibrisgroup.com",
    "aps": "https://api-aps.hosted.exlibrisgroup.com",
    "ca": "https://api-ca.hosted.exlibrisgroup.com",
    "cn": "https://api-cn.hosted.exlibrisgroup.com.cn",
}

# Output directories (relative to current working directory)
LETTERS_DIR = Path("letters")
COMPONENTS_DIR = Path("components")

# Will be set in main()
API_KEY = None
BASE_URL = None


def get_headers(content_type="json"):
    """Return headers for API requests."""
    headers = {
        "Authorization": f"apikey {API_KEY}",
    }
    if content_type == "json":
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
    return headers


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


def push_letter(letter_code, xsl_content):
    """
    Push XSL content for a letter back to Alma.

    Args:
        letter_code: The unique code identifying the letter.
        xsl_content: The XSL template content to upload.

    Returns:
        True if successful, raises exception otherwise.
    """
    # First fetch the current letter to get its full structure
    url = f"{BASE_URL}/conf/letters/{letter_code}"

    current = fetch_letter_detail(letter_code)

    # Update only the XSL content
    current["xsl"] = xsl_content

    response = requests.put(url, headers=get_headers(), json=current)
    response.raise_for_status()

    return True


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


def push_letters(letter_type, source_dir):
    """
    Push all letters/components of the given type from local files to Alma.

    Args:
        letter_type: "LETTER" or "COMPONENT"
        source_dir: Directory containing XSL files.

    Returns:
        List of pushed letter codes.
    """
    if not source_dir.exists():
        print(f"  Directory not found: {source_dir}")
        return []

    # Load the list of letters to push
    list_file = "letters.txt" if letter_type == "LETTER" else "components.txt"
    explicit_codes = load_letter_list(list_file)

    if not explicit_codes:
        print(f"  No {list_file} found, skipping {letter_type.lower()}s")
        return []

    print(f"\nPushing {letter_type.lower()}s...")
    print(f"  {len(explicit_codes)} to push from {list_file}")

    pushed = []
    for code in explicit_codes:
        # Handle component codes (may or may not have .xsl)
        filename = code if code.endswith(".xsl") else f"{code}.xsl"
        file_path = source_dir / filename

        if not file_path.exists():
            print(f"  Skipping: {code} (file not found: {filename})")
            continue

        # For components, the API code includes .xsl
        api_code = filename if letter_type == "COMPONENT" else code

        print(f"  Uploading: {api_code}")
        xsl_content = file_path.read_text(encoding="utf-8")

        try:
            push_letter(api_code, xsl_content)
            pushed.append(api_code)
        except requests.exceptions.HTTPError as e:
            print(f"    Error: {e}")

    return pushed


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


def get_base_url():
    """
    Get the API base URL for the configured region.

    Returns:
        Base URL string
    """
    region = os.getenv("ALMA_REGION", "na").lower()
    if region not in REGION_URLS:
        print(f"Error: Unknown ALMA_REGION '{region}'")
        print(f"Valid regions: {', '.join(REGION_URLS.keys())}")
        sys.exit(1)
    return f"{REGION_URLS[region]}/almaws/v1"


def get_api_key(env_name=None):
    """
    Get the API key for the specified environment.

    Args:
        env_name: "sandbox", "production", or None for legacy key

    Returns:
        API key string
    """
    if env_name == "sandbox":
        key = os.getenv("ALMA_API_KEY_SANDBOX")
        if not key:
            print("Error: ALMA_API_KEY_SANDBOX not set in .env")
            sys.exit(1)
        return key
    elif env_name == "production":
        key = os.getenv("ALMA_API_KEY_PRODUCTION")
        if not key:
            print("Error: ALMA_API_KEY_PRODUCTION not set in .env")
            sys.exit(1)
        return key
    else:
        # Legacy: check for single key or sandbox key
        key = os.getenv("ALMA_API_KEY") or os.getenv("ALMA_API_KEY_SANDBOX")
        if not key:
            print("Error: No API key found. Set ALMA_API_KEY_SANDBOX in .env")
            sys.exit(1)
        return key


def print_usage():
    """Print usage information."""
    print("Usage: alma-letters [command] [options]")
    print()
    print("Commands:")
    print("  (none)              Export letters from Alma to local files")
    print("  push --env ENV      Push local files to Alma (ENV: sandbox or production)")
    print("  --debug             Show all available letters and their status")
    print()
    print("Examples:")
    print("  alma-letters                    # Export from Alma")
    print("  alma-letters push --env sandbox # Push to sandbox")
    print("  alma-letters push --env production # Push to production (requires confirmation)")
    print("  alma-letters --debug            # Debug mode")


def main():
    global API_KEY, BASE_URL

    # Load .env from current working directory
    env_path = Path.cwd() / ".env"
    load_dotenv(env_path)

    # Set base URL from region
    BASE_URL = get_base_url()

    # Parse command line arguments
    args = sys.argv[1:]

    # Handle --help
    if "--help" in args or "-h" in args:
        print_usage()
        return

    # Handle --debug
    if "--debug" in args:
        API_KEY = get_api_key()
        debug_letters("LETTER")
        print()
        debug_letters("COMPONENT")
        return

    # Handle push command
    if args and args[0] == "push":
        # Parse --env argument
        env_name = None
        if "--env" in args:
            env_idx = args.index("--env")
            if env_idx + 1 < len(args):
                env_name = args[env_idx + 1].lower()

        if env_name not in ("sandbox", "production"):
            print("Error: push requires --env sandbox or --env production")
            print()
            print_usage()
            sys.exit(1)

        # Confirmation for production
        if env_name == "production":
            print("=" * 50)
            print("WARNING: You are about to push to PRODUCTION")
            print("=" * 50)
            print()
            response = input("Type 'yes' to confirm: ")
            if response.lower() != "yes":
                print("Aborted.")
                sys.exit(0)
            print()

        API_KEY = get_api_key(env_name)

        print(f"Alma Letter Push ({env_name.upper()})")
        print("=" * 40)

        # Push letters
        letters = push_letters("LETTER", LETTERS_DIR)

        # Push components
        components = push_letters("COMPONENT", COMPONENTS_DIR)

        # Summary
        print("\n" + "=" * 40)
        print("Push complete!")
        print(f"  Letters pushed: {len(letters)}")
        print(f"  Components pushed: {len(components)}")

        return

    # Default: export
    API_KEY = get_api_key()

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
