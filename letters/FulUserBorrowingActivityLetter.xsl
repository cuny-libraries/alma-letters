<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
	extension-element-prefixes="date">

	<xsl:include href="header.xsl" />
	<xsl:include href="senderReceiver.xsl" />
	<xsl:include href="mailReason.xsl" />
	<xsl:include href="footer.xsl" />
	<xsl:include href="style.xsl" />

	<!-- Template to check and format due dates -->
	<xsl:template name="check_DueDate">
		<xsl:param name="concatDueDate" />
		<xsl:param name="completeDueDate" />
		<xsl:variable name="today" select="translate(substring-before(date:date-time(),'T'),'-','')"/>
		<xsl:choose>
			<xsl:when test="number($concatDueDate) &lt; number($today)">
				<span class="status-overdue">
					<xsl:value-of select="$completeDueDate"/> ⚠️ Overdue
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="due-soon">
					Due <xsl:value-of select="$completeDueDate"/>
				</span> 
			</xsl:otherwise>
		</xsl:choose>
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

				<!-- Terminate processing if there are no loans and only fines -->
				<xsl:if test="(notification_data/item_loans/item_loan or notification_data/overdue_item_loans/item_loan)='' and notification_data/organization_fee_list/string != ''">
					<xsl:message terminate="yes">NO LOANS - ONLY FINES ON ACCOUNT; NO EMAIL SENT.</xsl:message>
				</xsl:if>

				<!-- Display loans if there are current or overdue loans -->
				<xsl:if test="notification_data/item_loans/item_loan or notification_data/overdue_item_loans/item_loan">
					<p>Here's a quick summary of your current library activity:</p>
					
					<!-- Overdue items first - high priority -->
					<xsl:if test="notification_data/overdue_item_loans/item_loan">
						<div class="overdue-section">
							<h2 class="section-title overdue-header">Items Overdue - Please Return</h2>
							<div class="loan-list">
								<xsl:for-each select="notification_data/overdue_item_loans/item_loan">
									<div class="loan-item overdue-item">
										<h3 class="item-title">
											<xsl:value-of select="title"/>
											<xsl:if test="normalize-space(description) != ''">
												: <span class="item-description"><xsl:value-of select="description"/></span>
											</xsl:if>
										</h3>
										<p class="due-info">
											<xsl:call-template name="check_DueDate">
												<xsl:with-param name="completeDueDate" select="new_due_date_str"/>
												<xsl:with-param name="concatDueDate" select="concat(substring(due_date,7),substring(due_date,1,2),substring(due_date,4,2))"/>   
											</xsl:call-template>
										</p>
									</div>
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>

					<xsl:if test="notification_data/item_loans/item_loan">
						<div class="current-section">
							<h2 class="section-title">Currently Borrowed</h2>
							<div class="loan-list">
								<xsl:for-each select="notification_data/item_loans/item_loan">
									<div class="loan-item">
										<h3 class="item-title">
											<xsl:value-of select="title"/>
											<xsl:if test="normalize-space(description) != ''">
												: <span class="item-description"><xsl:value-of select="description"/></span>
											</xsl:if>
										</h3>
										<p class="due-info">
											<span class="due-soon">Due <xsl:value-of select="new_due_date_str"/></span>
										</p>
									</div>
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>
				</xsl:if>

				<xsl:if test="notification_data/organization_fee_list/string != ''">
					<div class="fees-section">
						<h2 class="section-title">Account Notice</h2>
						<p>
							<strong>You have fines or fees on your account.</strong> 
							Check your <a href="@@email_my_account@@" target="_blank">library account</a> for details.
						</p>
					</div>
				</xsl:if>

				<xsl:call-template name="managingYourLoans" />
				<xsl:call-template name="lastFooter" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>