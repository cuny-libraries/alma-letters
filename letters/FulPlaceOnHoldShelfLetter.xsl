<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="library_account" select="'@@email_my_account@@'" />

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
				<xsl:call-template name="bodyStyleCss" /> <!-- style.xsl -->
			</xsl:attribute>

				<xsl:call-template name="head" /> <!-- header.xsl -->
				<xsl:call-template name="senderReceiver" /> <!-- SenderReceiver.xsl -->

				<xsl:call-template name="toWhomIsConcerned" /> <!-- mailReason.xsl -->

<p>@@following_item_requested_on@@ <xsl:value-of select="notification_data/request/create_date"/> @@can_picked_at@@ <strong style="color:#b20000;text-transform:uppercase;"><xsl:value-of select="notification_data/request/assigned_unit_name"/></strong>:</p>

<div style="margin-left:25px;">
<xsl:call-template name="recordTitle" /> <!-- recordTitle.xsl -->
</div>

<xsl:if test="notification_data/request/system_notes != ''">
<p><strong>@@notes_affect_loan@@</strong>:</p>
<blockquote style="font-style:italic;"><xsl:value-of select="notification_data/request/system_notes"/></blockquote>
</xsl:if>

<xsl:if test="notification_data/request/work_flow_entity/expiration_date != ''">
<p>@@note_item_held_until@@ <strong><xsl:value-of select="notification_data/request/work_flow_entity/expiration_date"/></strong>. If you cannot pick it up before then, please call the <xsl:value-of select="/notification_data/phys_item_display/owning_library_details/name" /> at <xsl:value-of select="/notification_data/phys_item_display/owning_library_details/phone" /> or email us at <a><xsl:attribute name="href">mailto:<xsl:value-of select="/notification_data/phys_item_display/owning_library_details/email"/></xsl:attribute><xsl:value-of select="/notification_data/phys_item_display/owning_library_details/email"/></a> so we can help.</p>
</xsl:if>

<p>Before you come, please make sure your <a><xsl:attribute name="href">@@email_my_account@@</xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>library account</a> is in good standing. This means:</p>
<ul>
<li>No overdue <a><xsl:attribute name="href"><xsl:value-of select="concat($library_account, '&amp;section=loans')" /></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>loans</a></li>
<li>No unpaid <a><xsl:attribute name="href"><xsl:value-of select="concat($library_account, '&amp;section=fines')" /></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>fines</a></li>
<li>Your account is <a><xsl:attribute name="href"><xsl:value-of select="concat($library_account, '&amp;section=personal_details')" /></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>not expired</a> (that is, you are a <em>currently active</em> CUNY student, staff, or faculty member)</li>
</ul>

<p>If there are any issues, our staff will be happy to assist you in resolving them to ensure a smooth pickup process.</p>

<p>If you do not need the item anymore, you can cancel the request. Just log in to your <a><xsl:attribute name="href">@@email_my_account@@</xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>library account</a>, go to "Requests," and click the ❌ <strong>CANCEL</strong> button next to the item you want to cancel.</p>

<p>We hope to see you soon at the library!</p>

				<xsl:call-template name="lastFooter" /> <!-- footer.xsl -->
			</body>
	</html>
	</xsl:template>

</xsl:stylesheet>