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

				<p>The following library items you borrowed are long overdue and now considered "Lost":</p>

				<xsl:for-each select="notification_data/loans_by_library/library_loans_for_display">
					<div class="overdue-section">
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
										<strong>Description:</strong> <xsl:value-of select="item_loan/description"/><br />
									</xsl:if>
									<strong>Loan Date</strong>: <xsl:value-of select="item_loan/loan_date"/><br />
									<strong>Due Date</strong>: <span class="status-overdue"><xsl:value-of select="item_loan/new_due_date_str"/></span><br />
									<strong>Overdue</strong>: <span class="status-overdue"><xsl:variable name="days-overdue">
											<xsl:call-template name="calculate-days-overdue">
												<xsl:with-param name="due-date" select="item_loan/new_due_date_str" />
												<xsl:with-param name="current-date" select="/notification_data/general_data/current_date" />
											</xsl:call-template>
										</xsl:variable>
										<xsl:value-of select="$days-overdue" /> days</span><br />
									<xsl:if test="normalize-space(item_loan/barcode) != ''">
										<strong>Barcode</strong>: <xsl:value-of select="item_loan/barcode"/><br />
									</xsl:if>
									<xsl:if test="normalize-space(physical_item_display_for_printing/call_number) != ''">
										<strong>Call Number</strong>: <xsl:value-of select="physical_item_display_for_printing/call_number"/>
									</xsl:if>
								
								<!-- Display any associated fees -->
								<xsl:if test="fines_fees_list/user_fines_fees">
									<br /><strong>Fines and Fees</strong>:
									<ul style="margin-top:-15px;margin-left:-15px;">
										<xsl:for-each select="fines_fees_list/user_fines_fees">
											<li>
												<strong><xsl:value-of select="fine_fee_type_display"/></strong>: 
												$<xsl:value-of select="fine_fee_ammount/normalized_sum"/>
											</li>
										</xsl:for-each>
									</ul>
								</xsl:if>
								</p>
							</div>
						</xsl:for-each>
					</div>
				</xsl:for-each>

				<!-- Important notice about fees -->
				<div class="warning-box">
					<strong>This is not a bill!</strong> The fines and fees shown here are estimates and may change. 
					Check your <a href="@@email_my_account@@" target="_blank">library account</a> for the most current information.
				</div>
				
				<div class="danger-box">
				    <strong>Important Notice</strong>: If this matter is not resolved, your library privileges may be suspended. 
				    Please contact us to discuss your options and avoid any interruption to your library access.
				</div>

				<div class="action-section">
					<h2 class="section-title">What to Do Next</h2>
					<p>We want to resolve this quickly so your library access stays active. Please take one of these steps:</p>
                    <ul>
                        <li><strong>Found your items?</strong> Return them <acronym title="As Soon As Possible">ASAP</acronym>—we'll waive the lost item fees (though overdue fines may still apply).</li>
                        <li><strong>Can't locate them?</strong> No worries! Contact us to discuss options.</li>
                        <li><strong>Need more time to search?</strong> Let us know - we can work with you.</li>
                    </ul>
                    <p>We may need to temporarily pause your library access until we resolve this together.</p>
				</div>

				<xsl:call-template name="lastFooter" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>