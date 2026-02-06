<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="header.xsl" />
	<xsl:include href="senderReceiver.xsl" />
	<xsl:include href="mailReason.xsl" />
	<xsl:include href="footer.xsl" />
	<xsl:include href="style.xsl" />
	<xsl:include href="recordTitle.xsl" />
	
	<!-- Template to calculate days overdue -->
	<xsl:template name="calculate-days-overdue">
		<xsl:param name="due-date" />
		<xsl:param name="current-date" />
		
		<!-- Parse current date (MM/DD/YYYY format) -->
		<xsl:variable name="current-month" select="substring-before($current-date, '/')" />
		<xsl:variable name="current-day" select="substring-before(substring-after($current-date, '/'), '/')" />
		<xsl:variable name="current-year" select="substring-after(substring-after($current-date, '/'), '/')" />
		
		<!-- Parse due date - extract first 10 characters (MM/DD/YYYY) and ignore time -->
		<xsl:variable name="due-date-only" select="substring($due-date, 1, 10)" />
		<xsl:variable name="due-month" select="substring-before($due-date-only, '/')" />
		<xsl:variable name="due-day" select="substring-before(substring-after($due-date-only, '/'), '/')" />
		<xsl:variable name="due-year" select="substring-after(substring-after($due-date-only, '/'), '/')" />
		
		<!-- Convert to days since epoch for calculation -->
		<xsl:variable name="current-days" select="
			($current-year * 365) + 
			floor($current-year div 4) - floor($current-year div 100) + floor($current-year div 400) +
			floor(($current-month - 1) * 30.44) + 
			$current-day
		" />
		
		<xsl:variable name="due-days" select="
			($due-year * 365) + 
			floor($due-year div 4) - floor($due-year div 100) + floor($due-year div 400) +
			floor(($due-month - 1) * 30.44) + 
			$due-day
		" />
		
		<xsl:value-of select="$current-days - $due-days" />
	</xsl:template>

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

				<p>The following items from your library account are overdue and need to be returned or renewed:</p>

				<xsl:for-each select="notification_data/loans_by_library/library_loans_for_display">
					<div class="overdue-section">
						<h2 class="section-title overdue-header">
							<xsl:value-of select="organization_unit/name" />
						</h2>
						
						<xsl:for-each select="item_loans/overdue_and_lost_loan_notification_display">
							<div class="info-box">
								<h3>
									<xsl:value-of select="item_loan/title"/>
									<xsl:if test="normalize-space(item_loan/author) != ''">
										 by <xsl:value-of select="item_loan/author"/>
									</xsl:if>
								</h3>
								
								<p>
									<xsl:if test="normalize-space(item_loan/description) != ''">
										<strong>Description</strong>: <xsl:value-of select="item_loan/description"/><br />
									</xsl:if>
									<strong>Loan Date</strong>: <xsl:value-of select="item_loan/loan_date"/><br />
									<strong>Due Date</strong>: <span class="status-overdue"><xsl:value-of select="item_loan/new_due_date_str"/></span><br />
									<strong>Days Overdue</strong>: <span class="status-overdue">
										<xsl:variable name="days-overdue">
											<xsl:call-template name="calculate-days-overdue">
												<xsl:with-param name="due-date" select="item_loan/new_due_date_str" />
												<xsl:with-param name="current-date" select="/notification_data/general_data/current_date" />
											</xsl:call-template>
										</xsl:variable>
										<xsl:value-of select="$days-overdue" /> days
									</span>
									<xsl:if test="normalize-space(item_loan/barcode) != ''">
										<br /><strong>Barcode</strong>: <xsl:value-of select="item_loan/barcode"/>
									</xsl:if>
								</p>
							</div>
						</xsl:for-each>
					</div>
				</xsl:for-each>

				<div class="action-section">
					<h2 class="section-title">What to Do Next</h2>
					<p>Don't worry—we're here to help! Here are your options:</p>
					
					<ul>
						<li><strong>Return the items</strong> to any CUNY library (books only—equipment must go back to the original library)</li>
						<li><strong>Renew online</strong> through your <a href="@@email_my_account@@" target="_blank">library account</a> if eligible</li>
						<li><strong>Contact us</strong> if you've lost the items or have questions about your account</li>
					</ul>
					
					<p>Returning items as soon as possible will prevent additional fines and keep your library account in good standing.</p>
				</div>

				<xsl:call-template name="lastFooter" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>