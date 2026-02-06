<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
				
				<p>Here's what you returned to <xsl:value-of select="notification_data/organization_unit/name"/>:</p>
		
				<xsl:for-each select="notification_data/loans_by_library/library_loans_for_display">
					<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display/item_loan">
						<!-- Item details - single info box matching LoanReceiptLetter format -->
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
								<strong>Due Date</strong>: <xsl:value-of select="new_due_date_str"/><br />
								<strong>Return Date</strong>: <xsl:value-of select="return_date_str"/><br />
								<xsl:if test="normalize-space(normalized_fine) != '' and normalize-space(normalized_fine) != '0.00'">
									<strong>Fine</strong>: <xsl:value-of select="normalized_fine"/><br />
								</xsl:if>
								<strong>From</strong>: <xsl:value-of select="library_name"/>
							</p>
						</div>
					</xsl:for-each>
				</xsl:for-each>
				
				<xsl:call-template name="lastFooter" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>