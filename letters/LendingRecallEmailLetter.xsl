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
					<xsl:call-template name="bodyStyleCss" /> <!-- style.xsl -->
				</xsl:attribute>
				<xsl:call-template name="head" /> <!-- header.xsl -->
				<xsl:call-template name="toWhomIsConcerned" /> <!-- mailReason.xsl -->

			  <p>@@header@@</p>

						<table cellpadding="5" class="listing" width="100%">
							<xsl:attribute name="style">
								<xsl:call-template name="mainTableStyleCss" /> <!-- style.xsl -->
							</xsl:attribute>
							<thead><tr>
								<th>@@title@@</th>
								<th>@@author@@</th>
								<th>@@old_due_date@@</th>
								<th>@@due_date@@</th>
							</tr></thead>
							<tbody><tr>
								<td><xsl:value-of select="notification_data/request/display/title"/></td>
								<td><xsl:value-of select="notification_data/request/display/author"/></td>
								<td><xsl:value-of select="notification_data/original_due_date"/></td>
								<td style="color:#ff0000;"><xsl:value-of select="notification_data/request/due_date"/></td>
							</tr></tbody>
                		</table>

<p>@@recall_message@@</p>

				<xsl:call-template name="lastFooter" /> <!-- footer.xsl -->
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
