# CUNY Libraries Alma Letters

This is a collection of XSL files used to generate letters and slips in Alma, as customized by the Office of Library Services at The City University of New York, on behalf of the University's 31 libraries across 26 campuses. These templates have been designed for consistency across the CUNY system.

## Overview

The CUNY library system consists of 26 campuses serving over 270,000 patrons. These letter templates provide a unified user experience while accommodating the specific needs of each campus library.

## Export Tool

This repository includes a Python tool to export customized letters from Alma via the Configuration API, making it easy to keep this repository in sync with Alma.

### Setup

1. Install with pipx:
   ```bash
   pipx install .
   ```

2. Create a `.env` file with your Alma API key:
   ```bash
   cp .env.example .env
   # Edit .env and add your API key
   ```
   Your API key needs read access to the Configuration API (NA data center).

### Usage

Run the export command from this directory:

```bash
alma-letters
```

This will:
- Fetch all letters and components from Alma
- Filter to only those listed in `letters.txt` and `components.txt`
- Download the XSL content for each
- Save to `letters/` and `components/` directories

### Configuration Files

- **`letters.txt`** - List of letter codes to export (one per line)
- **`components.txt`** - List of component codes to export (one per line)

To add a new letter to the export, add its code to the appropriate file. Comments (lines starting with `#`) are ignored.

### Debug Mode

To see all available letters and their status without exporting:

```bash
alma-letters --debug
```

## Letter Usage Statistics

Based on analysis from May 2025, our most frequently used fulfillment letters include:

| Letter Type | Volume | Percentage |
|-------------|--------|------------|
| Periodic Fulfillment Activity Report (BorrowingActivityLetter) | 36,959 | 69.8% |
| Courtesy Notices (CourtesyLetter) | 11,082 | 20.9% |
| Due Date Reminders (OverdueNoticeLetter) | 4,111 | 7.8% |
| Hold Shelf Reminders (OnHoldShelfReminderLetter) | 767 | 1.4% |
| **Total Fulfillment Letters** | **52,919** | **100%** |

*Note: This data represents fulfillment letters only and does not include slips printed or notices sent in other areas such as acquisitions.*

## Key Customizations

### Design Philosophy

* Accessibility-first approach: High contrast mode support, semantic HTML, and clear typography
* Mobile-responsive design: Templates work across all device types
* User-centered messaging: Clear, helpful language that reduces library anxiety

### Major Features

1. **Enhanced User Experience**
   * Emoji integration for visual clarity (📚, 🚚, ⚠️)
   * Conditional messaging based on item status and user type
   * Streamlined information hierarchy

2. **Accessibility Compliance**
   * WCAG 2.1 AA compliant color contrasts
   * Screen reader friendly markup
   * Clear status indicators for overdue items

## File Organization

### Components (Shared Templates)

| File | Purpose |
|------|---------|
| `header.xsl` | Campus-specific headers and branding |
| `footer.xsl` | Contact information and account links |
| `style.xsl` | Base styling |
| `mailReason.xsl` | Greeting templates |
| `senderReceiver.xsl` | Sender/receiver information |

### Letters

#### Patron-Facing Letters

| File | Purpose |
|------|---------|
| `FulUserBorrowingActivityLetter.xsl` | Loan activity summaries |
| `FulUserLoansCourtesyLetter.xsl` | Courtesy notices for approaching due dates |
| `FulPlaceOnHoldShelfLetter.xsl` | Item ready for pickup notifications |
| `FulOnHoldShelfReminderLetter.xsl` | Pickup reminders |
| `FulUserOverdueNoticeLetter.xsl` | Overdue item notifications |
| `FulCancelRequestLetter.xsl` | Request cancellation notices |
| `FulItemChangeDueDateLetter.xsl` | Due date changes and recalls |
| `LendingRecallEmailLetter.xsl` | Recall notices |

#### Receipts

| File | Purpose |
|------|---------|
| `FulLoanReceiptLetter.xsl` | Checkout receipts |
| `FulReturnReceiptLetter.xsl` | Return receipts |
| `FineFeePaymentReceiptLetter.xsl` | Fine/fee payment receipts |

#### Collections Letters

| File | Purpose |
|------|---------|
| `FulOverdueAndLostLoanLetter.xsl` | Lost item notices with fee information |
| `FulOverdueAndLostLoanNotificationLetter.xsl` | Initial lost item notifications |

#### Other

| File | Purpose |
|------|---------|
| `ResendNotificationLetter.xsl` | Resend previous notifications |

## Resources

### Ex Libris Documentation

* [Using Templates to Update Letter Formatting and Content](https://knowledge.exlibrisgroup.com/Alma/Product_Documentation/010Alma_Online_Help_(English)/050Administration/050Configuring_General_Alma_Functions/070Configuring_Alma_Letters#Using_Templates_to_Update_Letter_Formatting_and_Content)
* [Letter List](https://knowledge.exlibrisgroup.com/Alma/Product_Documentation/010Alma_Online_Help_(English)/050Administration/050Configuring_General_Alma_Functions/070Configuring_Alma_Letters#Letter_List)
* [Automating Letter Exports](https://developers.exlibrisgroup.com/blog/automating-letter-and-code-table-exports-from-alma/)
* [Alma Configuration API](https://developers.exlibrisgroup.com/alma/apis/conf/)

### Community Resources

* [University of Oslo Libraries Alma Letters Repository](https://github.com/uio-library/alma-letters-ubo) - Excellent reference implementation with detailed documentation
* [Alma User Discussion List](https://exlibrisusers.org/postorius/lists/alma.exlibrisusers.org/)

### Technical References

* [XSLT 1.0 Specification](https://www.w3.org/TR/xslt-10/)
* [HTML Email Best Practices](https://www.campaignmonitor.com/css/) - CSS support across email clients
* [Web Content Accessibility Guidelines (WCAG) 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
