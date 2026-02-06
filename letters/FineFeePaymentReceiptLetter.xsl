<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="header.xsl" />
<xsl:include href="senderReceiver.xsl" />
<xsl:include href="mailReason.xsl" />
<xsl:include href="footer.xsl" />
<xsl:include href="style.xsl" />

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
				<xsl:call-template name="bodyStyleCss" /> <!-- style.xsl -->
			</xsl:attribute>

				<xsl:call-template name="head" /> <!-- header.xsl -->
				<xsl:call-template name="senderReceiver" /> <!-- SenderReceiver.xsl -->

				<br />
				<xsl:call-template name="toWhomIsConcerned" /> <!-- mailReason.xsl -->

<p>This is a receipt for the fines/fees you paid to the library<xsl:if  test="notification_data/transaction_id != ''" > (@@transaction_id@@ <xsl:value-of select="/notification_data/transaction_id"/>)</xsl:if>:</p>

				<xsl:for-each select="notification_data/labels_list">
				<table role='presentation'  cellspacing="0" cellpadding="5" border="0">
					<tr>
						<td><xsl:value-of select="letter.fineFeePaymentReceiptLetter.message"/></td>
					</tr>
				</table>
				<br />
				</xsl:for-each>

				<table cellpadding="5" class="listing">
				<xsl:attribute name="style">
					<xsl:call-template name="mainTableStyleCss" /> <!-- style.xsl -->
				</xsl:attribute>
<thead>
					<tr>
						<th>@@fee_type@@</th>
						<th>@@payment_date@@</th>
						<th>@@paid_amount@@</th>
						<th>@@note@@</th>
					</tr>
</thead>
<tbody>
					<xsl:for-each select="notification_data/user_fines_fees_list/user_fines_fees">
					<tr>
						<td><xsl:value-of select="fine_fee_type_display"/></td>
						<td><xsl:value-of select="create_date"/></td>
						<td align="right"><xsl:value-of select="fines_fee_transactions/fines_fee_transaction/transaction_ammount/currency"/>&#160;<xsl:value-of select="fines_fee_transactions/fines_fee_transaction/transaction_amount_display"/></td>
						<td><xsl:value-of select="fines_fee_transactions/fines_fee_transaction/transaction_note"/></td>
					</tr>
					</xsl:for-each>

					<tr>
						<td colspan="2" align="right"><strong>@@total@@:</strong></td>
						<td align="right"><xsl:value-of select="notification_data/total_amount_paid"/></td>
						<td></td>
					</tr>
</tbody>
				</table>
				<br />
				
				<xsl:call-template name="lastFooter" /> <!-- footer.xsl -->
				<xsl:call-template name="contactUs" />
			</body>
	</html>
</xsl:template>

</xsl:stylesheet>