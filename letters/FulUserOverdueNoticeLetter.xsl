<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="header.xsl" />
  <xsl:include href="senderReceiver.xsl" />
  <xsl:include href="mailReason.xsl" />
  <xsl:include href="footer.xsl" />
  <xsl:include href="style.xsl" />
  <xsl:include href="recordTitle.xsl" />

  <xsl:template match="/">
    <html>
        <xsl:if test="notification_data/languages/string">
            <xsl:attribute name="lang">
                <xsl:value-of select="notification_data/languages/string"/>
            </xsl:attribute>
        </xsl:if>

    <head>
        <title>
            <xsl:value-of select="notification_data/general_data/subject"/>
        </title>

        <xsl:call-template name="generalStyle" />
    </head>
    <body>
        <xsl:attribute name="style">
            <xsl:call-template name="bodyStyleCss" />
        </xsl:attribute>

        <xsl:call-template name="head" />
        <xsl:call-template name="senderReceiver" />
        <xsl:call-template name="toWhomIsConcerned" />

		<p>The following items are due back at the library:</p>

		<xsl:for-each select="notification_data/item_loans/item_loan">
			<div class="info-box">
				<h3>
					<xsl:value-of select="title"/>
					<xsl:if test="normalize-space(author) != ''">
						 by <xsl:value-of select="author"/>
					</xsl:if>
				</h3>
				
				<p>
					<xsl:if test="normalize-space(description) != ''">
						<strong>Description:</strong> <xsl:value-of select="description"/><br />
					</xsl:if>
					<strong>Due Date</strong>: <span class="status-overdue"><xsl:value-of select="new_due_date_str"/></span><br />
					<strong>Library</strong>: <xsl:value-of select="library_name"/>
				</p>
			</div>
		</xsl:for-each>

		<div class="warning-box">
			<strong>Important!</strong> Overdue items may accumulate late fees until they are returned or renewed.
		</div>

		<xsl:call-template name="managingYourLoans" />
        <xsl:call-template name="lastFooter" />
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>