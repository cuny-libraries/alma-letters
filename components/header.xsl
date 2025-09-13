<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="head">
  <div class="header-container">
		<table class="header-table" cellpadding="0" cellspacing="0">
			<tr>
				<td class="header-left">
					<h1 class="header-title">
						<xsl:value-of select="notification_data/general_data/subject"/>
					</h1>
				</td>
				<td class="header-right">
					<p class="header-info">
						<strong>Date</strong>: <xsl:value-of select="notification_data/general_data/current_date"/>
						<xsl:if test="notification_data/receivers/receiver/user/user_name != ''">
							<br/><strong>Patron ID</strong>: <xsl:value-of select="notification_data/receivers/receiver/user/user_name"/>
						</xsl:if>
					</p>
				</td>
			</tr>
		</table>
	</div>
</xsl:template>

</xsl:stylesheet>
