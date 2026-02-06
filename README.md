# CUNY Libraries Alma Letters

Customized XSL letter templates for Ex Libris Alma, maintained by the Office of Library Services at The City University of New York.

## About

CUNY's library system spans 26 campuses and serves over 270,000 patrons. These templates provide a consistent, accessible experience across all 31 CUNY libraries while accommodating campus-specific needs.

### Design Philosophy

- **Accessibility-first**: High contrast support, semantic HTML, WCAG 2.1 AA compliant
- **Mobile-responsive**: Templates work across all device types
- **User-centered**: Clear language that reduces library anxiety
- **Visual clarity**: Strategic use of emoji (📚, 🚚, ⚠️) for quick scanning

## Letters Included

### Components (Shared Templates)

| File | Purpose |
|------|---------|
| `header.xsl` | Campus-specific headers and branding |
| `footer.xsl` | Contact information and account links |
| `style.xsl` | Base styling |
| `mailReason.xsl` | Greeting templates |
| `senderReceiver.xsl` | Sender/receiver information |

### Patron Notices

| File | Purpose |
|------|---------|
| `FulUserBorrowingActivityLetter.xsl` | Loan activity summaries |
| `FulUserLoansCourtesyLetter.xsl` | Courtesy notices for approaching due dates |
| `FulPlaceOnHoldShelfLetter.xsl` | Item ready for pickup |
| `FulOnHoldShelfReminderLetter.xsl` | Pickup reminders |
| `FulUserOverdueNoticeLetter.xsl` | Overdue notifications |
| `FulCancelRequestLetter.xsl` | Request cancellations |
| `FulItemChangeDueDateLetter.xsl` | Due date changes and recalls |
| `LendingRecallEmailLetter.xsl` | Recall notices |
| `FulOverdueAndLostLoanLetter.xsl` | Lost item notices with fees |
| `FulOverdueAndLostLoanNotificationLetter.xsl` | Initial lost item notifications |
| `ResendNotificationLetter.xsl` | Resend previous notifications |

### Receipts

| File | Purpose |
|------|---------|
| `FulLoanReceiptLetter.xsl` | Checkout receipts |
| `FulReturnReceiptLetter.xsl` | Return receipts |
| `FineFeePaymentReceiptLetter.xsl` | Payment receipts |

## CLI Tool

This repository includes a command-line tool to sync letters between your local files and Alma via the Configuration API.

### Installation

```bash
pipx install .
```

### Configuration

Create a `.env` file from the template:

```bash
cp .env.example .env
```

Add your API keys (read/write access to Configuration API required):

```
ALMA_API_KEY_SANDBOX=your_sandbox_key
ALMA_API_KEY_PRODUCTION=your_production_key
ALMA_REGION=na
```

Available regions: `na`, `eu`, `ap`, `aps`, `ca`, `cn`

### Commands

**Export letters from Alma:**
```bash
alma-letters
```

**Push changes to Alma:**
```bash
alma-letters push --env sandbox      # Test in sandbox first
alma-letters push --env production   # Requires confirmation
```

**View available letters:**
```bash
alma-letters --debug
```

### Configuration Files

- `letters.txt` — Letter codes to sync (one per line)
- `components.txt` — Component codes to sync (one per line)

Lines starting with `#` are comments.

## Usage Statistics

Based on May 2025 data, fulfillment letter volume:

| Letter Type | Volume | Share |
|-------------|--------|-------|
| Borrowing Activity Report | 36,959 | 69.8% |
| Courtesy Notices | 11,082 | 20.9% |
| Overdue Notices | 4,111 | 7.8% |
| Hold Shelf Reminders | 767 | 1.4% |

*Fulfillment letters only; excludes acquisitions and other areas.*

## Roadmap

- [ ] GitHub Actions workflow for automated syncing
- [ ] Selective push (specific letters only)
- [ ] XSL validation before pushing
- [ ] Letter preview/testing tool

## Resources

### Ex Libris Documentation

- [Letter Customization Guide](https://knowledge.exlibrisgroup.com/Alma/Product_Documentation/010Alma_Online_Help_(English)/050Administration/050Configuring_General_Alma_Functions/070Configuring_Alma_Letters#Using_Templates_to_Update_Letter_Formatting_and_Content)
- [Letter List](https://knowledge.exlibrisgroup.com/Alma/Product_Documentation/010Alma_Online_Help_(English)/050Administration/050Configuring_General_Alma_Functions/070Configuring_Alma_Letters#Letter_List)
- [Automating Letter Exports](https://developers.exlibrisgroup.com/blog/automating-letter-and-code-table-exports-from-alma/)
- [Configuration API](https://developers.exlibrisgroup.com/alma/apis/conf/)

### Community

- [University of Oslo Alma Letters](https://github.com/uio-library/alma-letters-ubo) — Reference implementation
- [Alma User Discussion List](https://exlibrisusers.org/postorius/lists/alma.exlibrisusers.org/)

### Technical

- [XSLT 1.0 Specification](https://www.w3.org/TR/xslt-10/)
- [HTML Email CSS Support](https://www.campaignmonitor.com/css/)
- [WCAG 2.1 Quick Reference](https://www.w3.org/WAI/WCAG21/quickref/)
