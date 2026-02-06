<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="managingYourLoans">
		<div class="action-section">
			<h2 class="section-title">Managing Your Loans</h2>
			<ul>
				<li><strong>Return Items:</strong> Books can be returned to any CUNY library for your convenience. Equipment and other non-book items must be returned to the same library where they were borrowed and cannot be returned to other CUNY libraries.</li>
				<li><strong>Renew Online:</strong> Log in to your <a href="@@email_my_account@@" target="_blank">library account</a> to renew eligible items. <em>Note: Not all items can be renewed.</em></li>
			</ul>
		</div>
	</xsl:template>
	<xsl:template name="lastFooter">
		<div class="footer-info">
			<h2>Questions? We're here to help!</h2>
			<p>Contact the library by emailing us at 
				<a>
					<xsl:attribute name="href">mailto:
						<xsl:value-of select="notification_data/organization_unit/email/email"/>
					</xsl:attribute>
					<xsl:value-of select="notification_data/organization_unit/email/email"/>
				</a> or calling us at 
				<xsl:value-of select="notification_data/organization_unit/phone/phone"/> for assistance with your account or materials.
			</p>
		</div>
		<div class="footer-container">
			<table class="footer-table">
				<tr>
					<td class="footer-logo">
						<img src="cid:logo.jpg" alt="College Logo" class="logo-image"/>
					</td>
					<td class="footer-contact">
						<p>
							<strong>
								<xsl:value-of select="notification_data/organization_unit/name"/>
							</strong>
							<br/>
							<xsl:value-of select="notification_data/organization_unit/address/line1"/>
							<br/>
							<xsl:value-of select="notification_data/organization_unit/address/city"/>,<xsl:text> </xsl:text><xsl:value-of select="notification_data/organization_unit/address/state_province"/><xsl:text> </xsl:text><xsl:value-of select="notification_data/organization_unit/address/postal_code"/>
							<br/>
                        📞 
							<xsl:value-of select="notification_data/organization_unit/phone/phone"/>
							<br/>
                        ✉️ 
							<a>
								<xsl:attribute name="href">mailto:
									<xsl:value-of select="notification_data/organization_unit/email/email"/>
								</xsl:attribute>
								<xsl:value-of select="notification_data/organization_unit/email/email"/>
							</a>
						</p>
					</td>
					<td class="footer-links">
						<p>
                        👤 
					    	<a href="@@email_my_account@@" target="_blank">My Account</a><br />
                        🕘 
						    <a target="_blank">
						        <xsl:attribute name="href">
                                <xsl:call-template name="getCampusSpecificURL">
                                    <xsl:with-param name="urlType">hours</xsl:with-param>
                                    <xsl:with-param name="campusCode" select="notification_data/organization_unit/code" />
                                </xsl:call-template>
                            </xsl:attribute>
                            Library Hours
                            </a>
						</p>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template name="contactUs">
		<a href="@@email_contact_us@@">@@contact_us@@</a>
	</xsl:template>
	<xsl:template name="myAccount">
		<a href="@@email_my_account@@" target="_blank">@@my_account@@</a>
	</xsl:template>
</xsl:stylesheet>