<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="head">
    <div class="header-container">
        <table class="header-table">
            <tr>
                <td class="header-logo">
                    <img src="https://d2jv02qf7xgjwx.cloudfront.net/customers/3586/images/CUNY_Library_Services_WHITE.png" alt="CUNY Library Services Logo" />
                </td>
                <td class="header-left">
                    <h1 class="header-title">
                        <xsl:choose>
                            <xsl:when test="notification_data/general_data/letter_name = 'Request Cancel Letter'">
                                Request Update Letter
                            </xsl:when>
                            <xsl:when test="notification_data/general_data/letter_name = 'Lost Items Bill'">
                                Lost Items Letter
                            </xsl:when>
                            <xsl:when test="notification_data/general_data/letter_name = 'Long Overdue Items - Notification'">
                                Overdue Items Letter
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="notification_data/general_data/letter_name"/>
                            </xsl:otherwise>
                        </xsl:choose>
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