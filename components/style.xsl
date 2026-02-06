<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="generalStyle">
<style>
/* =================================================================
   CUNY UNIFIED EMAIL STYLES
   Based on CUNY.edu website design - Clean and Professional
   Primary: CUNY Blue (#0033A1) for headers/footers
   Background: White with Pearl (#F7F4EB) accents
   ================================================================= */

/* BASE STYLES - Email Client Safe */
body {
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    font-size: 16px;
    line-height: 1.6;
    color: #383838; /* Charcoal for body text */
    background-color: #ffffff;
    margin: 0;
    padding: 0;
    width: 100% !important;
    min-width: 100%;
    -webkit-text-size-adjust: 100%;
    -ms-text-size-adjust: 100%;
}

/* Email container */
.email-container {
    max-width: 600px;
    margin: 0 auto;
    background-color: #ffffff;
}

/* HEADER STYLING - Clean CUNY Blue like website */
.header-container {
    background-color: #0033A1; /* CUNY Blue */
    color: #ffffff;
    padding: 20px;
    margin-top: 0;
    margin-bottom: 20px;
}

.header-table {
    width: 100%;
    border-collapse: collapse;
}

.header-logo {
    width: 120px;
    vertical-align: middle;
    padding-right: 20px;
    background-color: #0033A1;
}

.header-logo img {
    max-height: 50px;
    max-width: 120px;
    height: auto;
    border: 0;
}

.header-left {
    text-align: left;
    vertical-align: middle;
    width: 70%;
}

.header-right {
    text-align: right;
    vertical-align: middle;
    width: 30%;
}

.header-title {
    margin: 0;
    font-size: 20px;
    color: #ffffff;
    font-family: Arial, sans-serif;
    font-weight: bold;
}

.header-logo {
    margin: 0;
    font-size: 24px;
    color: #ffffff;
    font-family: Arial, sans-serif;
    font-weight: bold;
    letter-spacing: 1px;
}

.header-info {
    margin: 5px 0 0 0;
    font-size: 14px;
    color: #ffffff;
    font-family: Arial, sans-serif;
    opacity: 0.9;
}

.header-info strong {
    color: #ffffff;
    font-weight: bold;
}

/* CONTENT AREA - Clean white background */
.content-area {
    background-color: #ffffff;
    padding: 30px 20px;
}

/* TYPOGRAPHY - Clean and readable */
h1, h2, h3, h4, h5, h6 {
    margin-top: 0;
    margin-bottom: 16px;
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    font-weight: bold;
}

h1 {
    font-size: 24px;
    color: #0033A1; /* CUNY Blue */
}

h2 {
    font-size: 20px;
    color: #0033A1; /* CUNY Blue */
}

h3 {
    font-size: 18px;
    color: #383838; /* Charcoal */
}

p {
    margin: 0 0 16px 0;
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    color: #383838; /* Charcoal */
}

/* LINKS - CUNY Blue */
a {
    color: #0033A1; /* CUNY Blue */
    text-decoration: underline solid #A3C9FF; /* CUNY Sky */
}

a:visited {
    color: #510C76; /* Grape */
    text-decoration: underline solid #DEC2EB; /* Thistle */
}

a:hover {
    color: #0033A1; /* CUNY Blue */
    text-decoration: underline solid #0033A1; /* CUNY Blue on hover */
}

a:focus {
    outline: 2px solid #0033A1;
    outline-offset: 2px;
}

/* TABLES - Clean design with subtle borders */
table {
    border-collapse: collapse;
    mso-table-lspace: 0pt;
    mso-table-rspace: 0pt;
}

.listing {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    border: 1px solid #D8D7D6; /* Dove gray border */
    background-color: #ffffff;
}

.listing th {
    background-color: #F7F4EB; /* Pearl - subtle header */
    color: #0033A1; /* CUNY Blue text */
    padding: 12px 8px;
    text-align: left;
    font-weight: bold;
    border-bottom: 2px solid #0033A1; /* CUNY Blue accent */
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    font-size: 14px;
}

.listing td {
    padding: 10px 8px;
    border-bottom: 1px solid #F7F4EB; /* Pearl separator */
    vertical-align: top;
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    color: #383838; /* Charcoal */
    background-color: #ffffff;
}

.listing tr:hover td {
    background-color: #F7F4EB; /* Pearl hover */
}

/* STATUS INDICATORS - Clean and accessible */
.status-overdue {
    color: #BF0D3E; /* Cranberry - accessible red */
    font-weight: bold;
}

.status-available {
    color: #005C5A; /* Sea Green - accessible green */
    font-weight: bold;
}

.status-warning {
    color: #C89210; /* Ochre - accessible orange */
    font-weight: bold;
}

.status-info {
    color: #0033A1; /* CUNY Blue */
    font-weight: bold;
}

/* INFO BOXES - Clean website-style design */
.info-box {
    background-color: #F7F4EB; /* Pearl background */
    border: 1px solid #D8D7D6; /* Dove border */
    border-left: 4px solid #0033A1; /* CUNY Blue accent */
    padding: 20px;
    margin: 25px auto;
    width: 90%;
    max-width: 540px;
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    border-radius: 4px;
}

.info-box strong {
    color: #0033A1; /* CUNY Blue */
}

.danger-box {
    background-color: #f8d7da;
    border: 1px solid #f5c6cb;
    border-left: 4px solid #BF0D3E; /* Cranberry accent */
    padding: 20px;
    margin: 25px auto;
    width: 90%;
    max-width: 540px;
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    border-radius: 4px;
}

.danger-box strong {
    color: #BF0D3E; /* Cranberry */
}

.warning-box {
    background-color: #FFFCD5; /* Cream background */
    border: 1px solid #FFB71B; /* Taxi yellow border */
    border-left: 4px solid #C89210; /* Ochre accent */
    padding: 20px;
    margin: 25px auto;
    width: 90%;
    max-width: 540px;
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    border-radius: 4px;
}

.warning-box strong {
    color: #C89210; /* Ochre */
}

.success-box {
    background-color: #E1F7EF;
    border: 1px solid #45C2B1; /* Liberty border */
    border-left: 4px solid #005C5A; /* Sea Green accent */
    padding: 20px;
    margin: 25px auto;
    width: 90%;
    max-width: 540px;
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    border-radius: 4px;
}

.success-box strong {
    color: #005C5A; /* Sea Green for emphasis */
}

/* FOOTER STYLING - Clean CUNY Blue like website */

.footer-info {
    background-color: #F0F1F1; /* Light gray */
    color: #000000;
    padding: 20px;
    margin-top: 30px;
    margin-bottom: 0;
}

.footer-info h2 {
    margin: 0 0 10px 0;
    font-size: 18px;
    font-weight: bold;
    color: #0033a1; /* Darker blue for heading */
}

.footer-info p {
    margin: 0;
    color: #383838; /* Charcoal text */
}

.footer-info a {
    color: #0033A1; /* CUNY Blue links */
    text-decoration: underline solid #A3C9FF; 
}

.footer-info a:hover {
    color: #0033A1; /* CUNY Blue links */
    text-decoration: underline solid #0033A1; 
}

.footer-info a:visited {
    color: #510C76; /* Grape */
    text-decoration: underline solid #DEC2EB; /* Thistle */
}

.footer-container {
    background-color: #0033A1; /* CUNY Blue */
    color: #ffffff;
    padding: 20px;
    margin-top: 0;
    margin-bottom: 0;
}

.footer-table {
    width: 100%;
    border-collapse: collapse;
}

.footer-separator {
    height: 3px;
    border: none;
    background-color: #FFB71B; /* Taxi yellow accent line */
    margin: 30px 0;
}

.footer-logo {
    width: 120px;
    vertical-align: top;
    padding-right: 20px;
}

.footer-contact,
.footer-contact p {
    vertical-align: top;
    padding-left: 20px;
    color: #ffffff;
}

.footer-links {
    width: 140px;
    vertical-align: top;
    text-align: right;
    padding-left: 20px;
}

.footer-contact a, 
.footer-links a {
    color: #ffffff;
    text-decoration: underline;
}

.logo-image {
    max-height: 60px;
    max-width: 120px;
    height: auto;
    border: 0;
}

/* IMAGES */
img {
    max-width: 100%;
    height: auto;
    border: 0;
    outline: none;
    text-decoration: none;
    -ms-interpolation-mode: bicubic;
}

/* GREETING AREA */
.greeting {
    background-color: #ffffff;
    padding: 20px;
    border-bottom: 1px solid #F7F4EB;
}

/* BORROWING ACTIVITY LETTER STYLES */

/* Section headers */
.section-title {
    font-size: 18px;
    font-weight: bold;
    color: #0033A1; /* CUNY Blue */
    margin: 25px 0 15px 0;
    padding-bottom: 8px;
    border-bottom: 3px solid #FFB71B; /* Taxi separator */
}

.overdue-header {
    color: #BF0D3E; /* Cranberry for urgency */
    border-bottom-color: #BF0D3E;
}

/* Loan list container */
.loan-list {
    margin: 0 0 20px 0;
}

/* Individual loan items */
.loan-item {
    background-color: #ffffff;
    border: 1px solid #D8D7D6; /* Dove gray border */
    border-left: 4px solid #0033A1; /* CUNY Blue accent */
    padding: 15px;
    margin: 0 0 12px 0;
    border-radius: 4px;
}

.loan-item.overdue-item {
    border-left-color: #BF0D3E; /* Cranberry for overdue */
    background-color: #FFF5F5; /* Very light red background */
}

/* Item titles */
.item-title {
    font-size: 16px;
    font-weight: bold;
    color: #383838; /* Charcoal */
    margin: 0 0 8px 0;
    line-height: 1.3;
}

.item-description {
    font-weight: normal;
    color: #688197; /* Slate */
    font-style: italic;
}

/* Due date info */
.due-info {
    margin: 0;
    font-size: 14px;
}

.due-soon {
    color: #0033A1; /* CUNY Blue */
    font-weight: bold;
}

.status-overdue {
    color: #BF0D3E; /* Cranberry */
    font-weight: bold;
}

.fees-section,
.contact-section {
    margin: 30px 0;
}

/* Section containers */
.overdue-section {
    margin: 20px 0 30px 0;
}

.current-section {
    margin: 20px 0;
}

/* MOBILE RESPONSIVE */
@media only screen and (max-width: 480px) {
    .email-container {
        width: 100% !important;
        max-width: 100% !important;
    }
    
    .header-container,
    .footer-container,
    .footer-info {
        padding: 15px 10px !important;
    }
    
    .header-logo {
        padding-bottom: 10px !important;
    }
    
    .header-logo img {
        max-height: 40px !important;
    }
    
    .content-area {
        padding: 20px 15px !important;
    }
    
    .listing {
        font-size: 14px !important;
    }
    
    .listing th,
    .listing td {
        padding: 8px 6px !important;
    }
    
    .info-box,
    .warning-box,
    .danger-box, 
    .success-box {
        margin: 10px 0 !important;
        padding: 12px !important;
        width: 90% !important;
        max-width: none !important;
    }
    
    .header-title {
        font-size: 18px !important;
    }
    
    .header-info {
        font-size: 12px !important;
    }
    
    .footer-table td,
    .header-table td {
        display: block !important;
        width: 100% !important;
        text-align: center !important;
        padding: 10px 0 !important;
    }
    
    .footer-links {
        text-align: center !important;
    }
    
    .loan-item {
        padding: 12px;
        margin: 0 0 10px 0;
    }
    
    .item-title {
        font-size: 15px;
    }
    
    .section-title {
        font-size: 16px;
        margin: 20px 0 12px 0;
    }
}

/* ACCESSIBILITY - High Contrast Mode */
@media (prefers-contrast: high) {
    .listing th {
        background-color: #000000;
        color: #ffffff;
        border: 2px solid #ffffff;
    }
    
    .info-box,
    .warning-box {
        border: 2px solid #000000;
        background-color: #ffffff;
    }
    
    .header-container,
    .footer-container {
        background-color: #000000;
        border: 2px solid #ffffff;
    }
    
    a {
        color: #000000;
        text-decoration: underline;
    }
    
    .footer-links a {
        background-color: #ffffff;
        color: #000000;
        border: 2px solid #000000;
    }
}

/* PRINT STYLES */
@media print {
    .header-container,
    .footer-container {
        background-color: #ffffff !important;
        color: #000000 !important;
        border: 2px solid #0033A1 !important;
    }
    
    .header-title {
        color: #0033A1 !important;
    }
    
    .listing th {
        background-color: #F7F4EB !important;
        color: #000000 !important;
        border: 1px solid #000000 !important;
    }
    
    .footer-separator {
        background: #000000 !important;
        height: 2px !important;
    }
    
    a {
        color: #0033A1 !important;
        text-decoration: underline !important;
    }
}

/* EMAIL CLIENT SPECIFIC FIXES */

/* Outlook specific */
.outlook-fix {
    mso-line-height-rule: exactly;
}

/* Gmail specific */
.gmail-fix {
    color: inherit !important;
    text-decoration: none !important;
}

/* Prevent unwanted blue links in some clients */
a[x-apple-data-detectors] {
    color: inherit !important;
    text-decoration: none !important;
    font-size: inherit !important;
    font-family: inherit !important;
    font-weight: inherit !important;
    line-height: inherit !important;
}

</style>
</xsl:template>

<!-- HELPER TEMPLATES FOR INLINE STYLES -->
<xsl:template name="bodyStyleCss">
font-family: Arial, "Helvetica Neue", Helvetica, sans-serif; color: #383838; margin: 0; padding: 0; line-height: 1.6; background-color: #ffffff;
</xsl:template>

<xsl:template name="listStyleCss">
list-style: none; margin: 0 0 0 1em; padding: 0;
</xsl:template>

<xsl:template name="mainTableStyleCss">
width: 100%; text-align: left; line-height: 1.6; border-collapse: collapse; background-color: #ffffff;
</xsl:template>

<xsl:template name="detailsTableStyleCss">
text-align: left; line-height: 1.6; font-size: 14px; background-color: #ffffff;
</xsl:template>

<xsl:template name="headerLogoStyleCss">
background-color: #0033A1; width: 100%; color: #ffffff;
</xsl:template>

<xsl:template name="headerTableStyleCss">
background-color: #0033A1; width: 100%; color: #ffffff;
</xsl:template>

<xsl:template name="footerTableStyleCss">
background-color: #0033A1; width: 100%; color: #ffffff; margin-top: 0;
</xsl:template>

</xsl:stylesheet>