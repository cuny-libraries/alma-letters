# alma-letters

This is a collection of XSL files used to generate letters and slips in Alma, as customized by the Office of Library Services at The City University of New York, on behalf of the University's 31 libraries across 26 campuses. These templates have been designed for consistency across the CUNY system.

## Overview
The CUNY library system consists of 26 campuses serving over 270,000 patrons. These letter templates provide a unified user experience while accommodating the specific needs of each campus library.

## Letter Usage Statistics
Based on analysis from May 2025, our most frequently used fulfillment letters include:

|Letter Type|Volume|Percentage|
|-|-|-|
|Periodic Fulfillment Activity Report (BorrowingActivityLetter)|36,959|69.8%|
|Courtesy Notices (CourtesyLetter)|11,082|20.9%|
|Due Date Reminders (OverdueNoticeLetter)|4,11|17.8%|
|Hold Shelf Reminders (OnHoldShelfReminderLetter)|767|1.4%|
|**Total Fulfillment Letters**|**52,919**|**100%**|

*Note: This data represents fulfillment letters only and does not include slips printed or notices sent in other areas such as acquisitions.*

## Key Customizations

### Design Philosophy
* Accessibility-first approach: High contrast mode support, semantic HTML, and clear typography
* Mobile-responsive design: Templates work across all device types
* User-centered messaging: Clear, helpful language that reduces library anxiety

### Major Features
1. Enhanced User Experience

    * Emoji integration for visual clarity (📚, 🚚, ⚠️)
    * Conditional messaging based on item status and user type
    * Streamlined information hierarchy

3. Accessibility Compliance

    * WCAG 2.1 AA compliant color contrasts
    * Screen reader friendly markup
    * Clear status indicators for overdue items

## File Organization

### Core Templates
* `header.xsl` - Campus-specific headers and branding
* `footer.xsl` - Contact information and account links
* `style.xsl` - Base styling
* `mailReason.xsl` - Greeting templates
* `senderReceiver.xsl` - Sender/receiver information
* `recordTitle.xsl` - Bibliographic information display

### Letter Templates

#### Patron-Facing Letters

* `BorrowingActivityLetter.xsl` - Loan activity summaries
* `CourtesyLetter.xsl` - Courtesy notices for approaching due dates
* `OnHoldShelfLetter.xsl` - Item ready for pickup notifications
* `OnHoldShelfReminderLetter.xsl` - Pickup reminders
* `OverdueNoticeLetter.xsl` - Overdue item notifications
* `FulCancelRequestLetter.xsl` - Request cancellation notices
* `LoanStatusNotice.xsl` - Due date changes and recalls
* `HoldShelfExpiryDateUpdateLetter.xsl` - Pickup deadline extensions

#### Staff-Facing Slips

* `FulResourceRequestSlipLetter.xsl` - Multi-purpose request slips
* `FulTransitSlipLetter.xsl` - Inter-campus shipping slips
* `ResourceSharingShippingSlipLetter.xsl` - External partner shipping
* `ResourceSharingReturnSlipLetter.xsl` - Return slips for borrowed items

#### Receipts and Confirmations

* `LoanReceiptLetter.xsl` - Checkout receipts
* `ReturnReceiptLetter.xsl` - Return receipts

#### Collections Letters

* `FulOverdueAndLostLoanLetter.xsl` - Lost item notices with fee information
* `FulOverdueAndLostLoanNotificationLetter.xsl` - Initial lost item notifications

## Resources

### Ex Libris Documentation
* [Using Templates to Update Letter Formatting and Content](https://knowledge.exlibrisgroup.com/Alma/Product_Documentation/010Alma_Online_Help_(English)/050Administration/050Configuring_General_Alma_Functions/070Configuring_Alma_Letters#Using_Templates_to_Update_Letter_Formatting_and_Content)
* [Letter List](https://knowledge.exlibrisgroup.com/Alma/Product_Documentation/010Alma_Online_Help_(English)/050Administration/050Configuring_General_Alma_Functions/070Configuring_Alma_Letters#Letter_List)
* [Letters on the Alma Developer Network](https://developers.exlibrisgroup.com/?s=letters)

### Community Resources

* [University of Oslo Libraries Alma Letters Repository](https://github.com/uio-library/alma-letters-ubo) - Excellent reference implementation with detailed documentation
* [Alma User Discussion List](https://exlibrisusers.org/postorius/lists/alma.exlibrisusers.org/)

### Technical References

* [XSLT 1.0 Specification](https://www.w3.org/TR/xslt-10/)
* [HTML Email Best Practices](https://www.campaignmonitor.com/css/) - CSS support across email clients
* [Web Content Accessibility Guidelines (WCAG) 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
