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
      <head>
        <xsl:call-template name="generalStyle" />
      </head>
      <body>
        <xsl:attribute name="style">
          <xsl:call-template name="bodyStyleCss" /><!-- style.xsl -->
        </xsl:attribute>

        <xsl:call-template name="head" /><!-- header.xsl -->
        <xsl:call-template name="senderReceiver" /> <!-- SenderReceiver.xsl -->

        <xsl:call-template name="toWhomIsConcerned" /> <!-- mailReason.xsl -->

<p>@@following_items_awaiting_pickup@@:</p>

                  <xsl:for-each select="notification_data/requests_by_library/library_requests_for_display">
                                <table cellpadding="5" class="listing">
                                    <xsl:attribute name="style">
                                        <xsl:call-template name="mainTableStyleCss" />
                                    </xsl:attribute>
                                    <thead>
                                       <tr align="center" bgcolor="#f5f5f5">
                                        <th colspan="4">
                                            <xsl:value-of select="organization_unit/name" />
                                        </th>
                                     </tr>
                                     <tr>
                                        <th>@@title@@</th>
                                        <th>@@author@@</th>
                                        <th>@@can_picked_at@@</th>
                                        <th>@@note_item_held_until@@</th>
                                    </tr>
</thead>
<tbody>
                                    <xsl:for-each select="requests/request_for_display">
                                        <tr>
                                            <td><xsl:value-of select="phys_item_display/title"/></td>
                                            <td><xsl:value-of select="phys_item_display/author"/></td>
                                            <td style="color:#b20000;font-weight:bold;"><xsl:value-of select="request/assigned_unit_name"/></td>
                                            <td style="color:#b20000;font-weight:bold;"><xsl:value-of select="request/work_flow_entity/expiration_date"/></td>
                                        </tr>
                                    </xsl:for-each>
</tbody>
                                </table>
                    </xsl:for-each>
                    <xsl:if test="notification_data/out_of_institution_requests/request_for_display">
                                <table cellpadding="5" class="listing">
                                    <xsl:attribute name="style">
                                        <xsl:call-template name="mainTableStyleCss" />
                                    </xsl:attribute>
                                    <thead><tr align="center" bgcolor="#f5f5f5">
                                        <th colspan="4">
                                            @@other_institutions@@
                                        </th>
                                    </tr>
                                    <tr>
                                        <th>@@title@@</th>
                                        <th>@@author@@</th>
                                        <th>@@can_picked_at@@</th>
                                        <th>@@note_item_held_until@@</th>
                                    </tr>
</thead>
<tbody>
                                    <xsl:for-each select="notification_data/out_of_institution_requests/request_for_display">
                                        <tr>
                                            <td><xsl:value-of select="phys_item_display/title"/></td>
                                            <td><xsl:value-of select="phys_item_display/author"/></td>
                                            <td style="color:#b20000;font-weight:bold;"><xsl:value-of select="request/assigned_unit_name"/></td>
                                            <td style="color:#b20000;font-weight:bold;"><xsl:value-of select="request/work_flow_entity/expiration_date"/></td>
                                        </tr>
                                    </xsl:for-each>
</tbody>
                                </table>
                    </xsl:if>

                    <xsl:if test="notification_data/user_for_printing/blocks != ''">
     <p><strong>@@notes_affect_loan@@</strong>:<br /><xsl:value-of select="notification_data/user_for_printing/blocks"/></p>
                    </xsl:if>

<p>@@message@@</p>

<xsl:choose>
<xsl:when test="notification_data/out_of_institution_requests/request_for_display">
<p>If you cannot pick up the items before the holds expire, please call the <xsl:value-of select="/notification_data/out_of_institution_requests/request_for_display/phys_item_display/owning_library_details/name" /> at <xsl:value-of select="/notification_data/out_of_institution_requests/request_for_display/phys_item_display/owning_library_details/phone" /> or email us at <a><xsl:attribute name="href">mailto:<xsl:value-of select="/notification_data/out_of_institution_requests/request_for_display/phys_item_display/owning_library_details/email"/></xsl:attribute><xsl:value-of select="/notification_data/out_of_institution_requests/request_for_display/phys_item_display/owning_library_details/email"/></a> so we can help.</p>
</xsl:when>
<xsl:otherwise>
<p>If you cannot pick up the items before the holds expire, please call the <xsl:value-of select="/notification_data/requests_by_library/library_requests_for_display/organization_unit/name" /> at <xsl:value-of select="/notification_data/requests_by_library/library_requests_for_display/organization_unit/phone/phone" /> or email us at <a><xsl:attribute name="href">mailto:<xsl:value-of select="/notification_data/requests_by_library/library_requests_for_display/organization_unit/email/email"/></xsl:attribute><xsl:value-of select="/notification_data/requests_by_library/library_requests_for_display/organization_unit/email/email"/></a> so we can help.</p>
</xsl:otherwise>
</xsl:choose>

<p>Before you come, please make sure your <a><xsl:attribute name="href">@@email_my_account@@</xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>library account</a> is in good standing. This means:</p>
<ul>
<li>No overdue <a><xsl:attribute name="href"><xsl:value-of select="concat($library_account, '&amp;section=loans')" /></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>loans</a></li>
<li>No unpaid <a><xsl:attribute name="href"><xsl:value-of select="concat($library_account, '&amp;section=fines')" /></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>fines</a></li>
<li>Your account is <a><xsl:attribute name="href"><xsl:value-of select="concat($library_account, '&amp;section=personal_details')" /></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>not expired</a> (that is, you are a <em>currently active</em> CUNY student, staff, or faculty member)</li>
</ul>

<p>If there are any issues, our staff will be happy to assist you in resolving them to ensure a smooth pickup process.</p>

<p>If you do not need the item anymore, you can cancel the request. Just log in to your <a><xsl:attribute name="href">@@email_my_account@@</xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>library account</a>, go to "Requests," and click the ❌ <strong>CANCEL</strong> button next to the item you want to cancel.</p>

<p>We hope to see you soon at the library!</p>

        <!-- footer.xsl -->
        <xsl:call-template name="lastFooter" />
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>