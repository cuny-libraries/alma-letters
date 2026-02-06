<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="header.xsl" />
  <xsl:include href="senderReceiver.xsl" />
  <xsl:include href="mailReason.xsl" />
  <xsl:include href="footer.xsl" />
  <xsl:include href="style.xsl" />
  <xsl:include href="recordTitle.xsl" />

	<!-- Check if any item has a description, author, item number, or requires equipment note -->
	<xsl:variable name="hasDescriptions">
		<xsl:for-each select="//notification_data/items/item_loan">
			<xsl:if test="normalize-space(description) != ''">
				<xsl:text>true</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="hasAuthors">
		<xsl:for-each select="//notification_data/items/item_loan">
			<xsl:if test="normalize-space(author) != ''">
				<xsl:text>true</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="hasItemNumbers">
		<xsl:for-each select="//notification_data/items/item_loan">
			<xsl:if test="normalize-space(alternative_call_number) != ''">
				<xsl:text>true</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<!-- Get campus code once at top level -->
	<xsl:variable name="campus_code" select="substring(notification_data/organization_unit/code, 1, 2)" />
	
	<xsl:variable name="hasEquipmentNotes">
		<xsl:for-each select="//notification_data/items/item_loan">
			<xsl:choose>
				<!-- Hunter College equipment locations -->
				<xsl:when test="$campus_code = 'HC' and (location_code='AVDC' or location_code='AVDH' or location_code='AVDW' or location_code='CAT' or location_code='SWIVC' or location_code='TAIPC' or location_code='TAIPCS')">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<!-- Bronx Community College equipment locations -->
				<xsl:when test="$campus_code = 'BX' and (location_code='EQUIP' or location_code='TECH' or location_code='AV')">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<!-- LaGuardia Community College equipment locations -->
				<xsl:when test="$campus_code = 'LG' and (location_code='MEDIA' or location_code='TECH' or location_code='EQUIP')">
					<xsl:text>true</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>

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
          <xsl:call-template name="bodyStyleCss" /><!-- style.xsl -->
        </xsl:attribute>

        <xsl:call-template name="head" /><!-- header.xsl -->
        <xsl:call-template name="senderReceiver" /> <!-- SenderReceiver.xsl -->
        <xsl:call-template name="toWhomIsConcerned" /> <!-- mailReason.xsl -->

				<p>Here's what you borrowed from <xsl:value-of select="notification_data/organization_unit/name" />:</p>
				
				<xsl:for-each select="notification_data/items/item_loan">
					<!-- Item details - single info box -->
					<div class="info-box">
						<h3>
							<xsl:value-of select="title" />
							<xsl:if test="normalize-space(author) != ''">
								 by <xsl:value-of select="author" />
							</xsl:if>
						</h3>
						
						<p>
						<xsl:if test="normalize-space(description) != ''">
						<strong>Description:</strong> <xsl:value-of select="description" /><br />
						</xsl:if>
						<strong>Due Date</strong>: <span class="status-overdue"><xsl:value-of select="new_due_date_str" /></span><br />
						<xsl:if test="normalize-space(call_number) != ''">
							 <strong>Call Number</strong>: <xsl:value-of select="call_number" />
						</xsl:if>
						<xsl:if test="normalize-space(alternative_call_number) != ''">
							 | <strong>Item Number</strong>: <xsl:value-of select="alternative_call_number" />
						</xsl:if>
						<xsl:choose>
							<xsl:when test="normalize-space(from_another_inst) != ''">
								<strong>From</strong>: <xsl:value-of select="translate(from_another_inst, '[]', '')" />
							</xsl:when>
							<xsl:when test="item_policy='RS_SUNY' or physical_item/item_policy='RS_SUNY'">
								<strong>From</strong>: Partner library at SUNY
							</xsl:when>
						</xsl:choose>
						<!-- Equipment note for specific location codes by campus -->
						<xsl:variable name="device">
						<xsl:choose>
							<!-- Hunter College equipment locations -->
							<xsl:when test="$campus_code = 'HC' and (location_code='AVDC' or location_code='AVDH' or location_code='AVDW' or location_code='CAT' or location_code='SWIVC' or location_code='TAIPC' or location_code='TAIPCS')">1</xsl:when>
							<!-- Bronx Community College equipment locations -->
							<xsl:when test="$campus_code = 'BX' and (location_code='EQUIP' or location_code='TECH' or location_code='AV')">1</xsl:when>
							<!-- LaGuardia Community College equipment locations -->
							<xsl:when test="$campus_code = 'LG' and (location_code='MEDIA' or location_code='TECH' or location_code='EQUIP')">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
    					</xsl:variable>
    					<xsl:if test="$device = 1">
    						<br /><strong>Equipment Responsibility</strong>: You are responsible for this equipment and its use as listed at: 
    							<xsl:choose>
    								<xsl:when test="$campus_code = 'HC'">
    									<a href="https://library.hunter.cuny.edu/technology-loans" target="_blank">https://library.hunter.cuny.edu/technology-loans</a>
    								</xsl:when>
    								<xsl:when test="$campus_code = 'BX'">
    									<a href="https://bcc-cuny.libguides.com/equipment" target="_blank">https://bcc-cuny.libguides.com/equipment</a>
    								</xsl:when>
    								<xsl:when test="$campus_code = 'LG'">
    									<a href="https://library.laguardia.edu/technology" target="_blank">https://library.laguardia.edu/technology</a>
    								</xsl:when> 
    							</xsl:choose>
    					</xsl:if>
						</p>
					</div>
				</xsl:for-each>
				<xsl:call-template name="managingYourLoans" />
        <xsl:call-template name="lastFooter" /> <!-- footer.xsl -->
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>