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
	<xsl:include href="recordTitle.xsl" />

	<!-- Template to check and format due dates -->
	<xsl:template name="check_DueDate">
		<xsl:param name="concatDueDate" />
		<xsl:param name="completeDueDate" />
		<xsl:variable name="today" select="translate(substring-before(date:date-time(),'T'),'-','')"/>
		<xsl:choose>
			<xsl:when test="number($concatDueDate) &lt; number($today)">
				<span class="status-overdue">
					<xsl:value-of select="$completeDueDate"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:value-of select="$completeDueDate"/>
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

				<!-- Display loans table if there are current or overdue loans -->
				<xsl:if test="notification_data/item_loans/item_loan or notification_data/overdue_item_loans/item_loan">
					<p>@@reminder_message@@:</p>
					
					<table width="95%" cellpadding="3" class="listing">
						<xsl:attribute name="style">
							<xsl:call-template name="mainTableStyleCss" />
						</xsl:attribute>
						<thead>
							<tr>
								<th width="54%">@@title@@</th>
								<th width="9%">@@due_date@@</th>
								<th width="22%">@@library@@</th>
								<th width="15%">@@call_number@@</th>
							</tr>
						</thead>
						<tbody>
							<!-- Display overdue items first -->
							<xsl:for-each select="notification_data/overdue_item_loans/item_loan">
								<tr>
									<td>
										<xsl:value-of select="title"/>
										<xsl:if test="normalize-space(description) != ''">
											&#160;<xsl:value-of select="description"/>
										</xsl:if>
									</td>
									<td>
										<xsl:call-template name="check_DueDate">
											<xsl:with-param name="completeDueDate" select="new_due_date_str"/>
											<xsl:with-param name="concatDueDate" select="concat(substring(due_date,7),substring(due_date,1,2),substring(due_date,4,2))"/>   
										</xsl:call-template> ⚠️
									</td>
									<td><xsl:value-of select="library_name"/></td>
									<td><xsl:value-of select="call_number"/></td>
								</tr>
							</xsl:for-each>

							<!-- Display current loans -->
							<xsl:for-each select="notification_data/item_loans/item_loan">
								<tr>
									<td>
										<xsl:value-of select="title"/>
										<xsl:if test="normalize-space(description) != ''">
											&#160;<xsl:value-of select="description"/>
										</xsl:if>
									</td>
									<td><xsl:value-of select="new_due_date_str"/></td>
									<td><xsl:value-of select="library_name"/></td>
									<td><xsl:value-of select="call_number"/></td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>

					<p>When you're finished with the material, please return it.</p>
					<div style="background-color:#e8f4fd; border:1px solid #bee5eb; padding:15px; margin:20px auto; border-radius:4px; width:90%;">
					    <strong>Return Information:</strong>
					    <ul>
					        <li><strong>Books:</strong> Can be returned to any CUNY library</li>
					        <li><strong>Equipment &amp; Other Materials:</strong> Must be returned to the library where borrowed</li>
					   </ul>
					</div>
					<p>
						If you need to keep the material longer, no problem! Just log into your 
						<a>
							<xsl:attribute name="href">@@email_my_account@@</xsl:attribute>
							<xsl:attribute name="target">_blank</xsl:attribute>
							library account
						</a> 
						and navigate to "Loans" for renewal options. 
						(Please note that not <em>all</em> loans are eligible for renewal.)
					</p>
				</xsl:if>

				<!-- Display appropriate fine/fee messages -->
				<xsl:choose>
					<xsl:when test="(notification_data/item_loans/item_loan or notification_data/overdue_item_loans/item_loan) and notification_data/organization_fee_list/string != ''">
						<p>
							Additionally, you should be aware that there are fines/fees on your 
							<a>
								<xsl:attribute name="href">@@email_my_account@@</xsl:attribute>
								<xsl:attribute name="target">_blank</xsl:attribute>
								library account
							</a>.
						</p>
					</xsl:when>
					<xsl:when test="(notification_data/item_loans/item_loan or notification_data/overdue_item_loans/item_loan)='' and notification_data/organization_fee_list/string != ''">
						<p>
							This is a note to let you know that there are fines/fees on your 
							<a>
								<xsl:attribute name="href">@@email_my_account@@</xsl:attribute>
								<xsl:attribute name="target">_blank</xsl:attribute>
								library account
							</a>.
						</p>
					</xsl:when>
				</xsl:choose>

				<!-- Contact information -->
				<p>
					If you have any questions about your library activity, please contact the library by emailing us at 
					<a>
						<xsl:attribute name="href">mailto:<xsl:value-of select="notification_data/organization_unit/email/email"/></xsl:attribute>
						<xsl:value-of select="notification_data/organization_unit/email/email"/>
					</a> 
					(or reply to this email) or calling us at <xsl:value-of select="notification_data/organization_unit/phone/phone"/>.
				</p>

				<xsl:call-template name="lastFooter" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
