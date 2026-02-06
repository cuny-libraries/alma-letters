<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
					<xsl:call-template name="bodyStyleCss" />
				</xsl:attribute>
				
				<xsl:call-template name="head" />
				<xsl:call-template name="senderReceiver" />
				<xsl:call-template name="toWhomIsConcerned" />
				
				<xsl:choose>
					<xsl:when test="notification_data/request/status_note_display = 'Converted to resource sharing request'">
						<p>Your request from 
							<xsl:value-of select="notification_data/request/create_date" />
							 is being processed. We couldn't find it on our shelves so <strong>we're now searching other libraries to locate this item for you.</strong>
						</p>
					</xsl:when>
					<xsl:otherwise>
						<p>Your request from 
							<xsl:value-of select="notification_data/request/create_date" />
							 could not be completed. <strong>
							<xsl:choose>
								<xsl:when test="notification_data/request/status_note_display = 'Failed to locate potential suppliers'">
									We were unable to locate this item at any of our partner libraries.
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="notification_data/request/status_note_display" />
								</xsl:otherwise>
							</xsl:choose>
							</strong>
						</p>
					</xsl:otherwise>
				</xsl:choose>
				
				<div class="info-box">
					<h3>
						<xsl:value-of select="notification_data/phys_item_display/title" />
						<xsl:if test="notification_data/phys_item_display/author != ''">
							 by <xsl:value-of select="notification_data/phys_item_display/author" />
						</xsl:if>
					</h3>
					
					<xsl:if test="notification_data/phys_item_display/publisher != '' or notification_data/phys_item_display/publication_date != ''">
						<p>
							<xsl:if test="notification_data/phys_item_display/publisher != ''">
								Published by <xsl:value-of select="notification_data/phys_item_display/publisher" />
								<xsl:if test="notification_data/phys_item_display/publication_date != ''">, <xsl:value-of select="notification_data/phys_item_display/publication_date" /></xsl:if>
							</xsl:if>
							<xsl:if test="notification_data/phys_item_display/publisher = '' and notification_data/phys_item_display/publication_date != ''">
								Published <xsl:value-of select="notification_data/phys_item_display/publication_date" />
							</xsl:if>
						</p>
					</xsl:if>
					
					<xsl:if test="notification_data/phys_item_display/isbn != '' or notification_data/phys_item_display/call_number != ''">
						<p>
							<xsl:if test="notification_data/phys_item_display/isbn != ''">
								<strong>ISBN</strong>: <xsl:value-of select="notification_data/phys_item_display/isbn" />
							</xsl:if>
							<xsl:if test="notification_data/phys_item_display/isbn != '' and notification_data/phys_item_display/call_number != ''"> | </xsl:if>
							<xsl:if test="notification_data/phys_item_display/call_number != ''">
								<strong>Call Number</strong>: <xsl:value-of select="notification_data/phys_item_display/call_number" />
							</xsl:if>
						</p>
					</xsl:if>
					
					<xsl:if test="notification_data/request/note != ''">
						<p><strong>Your note:</strong> <xsl:value-of select="notification_data/request/note" /></p>
					</xsl:if>
				</div>

				<!-- ILL suggestion - only show for cancellations, not conversions -->
				<xsl:if test="notification_data/request/status_note_display != 'Converted to resource sharing request'">
					<p>You may be able to request this item through interlibrary loan. 
						<xsl:variable name="campus_code" select="substring(notification_data/organization_unit/code, 1, 2)" />
						<xsl:choose>
							<xsl:when test="$campus_code = 'BB'">
								<a href="https://library.baruch.cuny.edu/help/interlibrary-loan/" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'BC'">
								<a href="https://libguides.brooklyn.cuny.edu/interlibraryloan" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'BM'">
								<a href="https://www.bmcc.cuny.edu/library/services/borrow-renew-request/interlibrary-loan/" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'BX'">
								<a href="https://www.bcc.cuny.edu/library/library-faculty/library-faculty-illiad/" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'CC'">
								<a href="https://library.ccny.cuny.edu/services/ILL" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'CL'">
								<a href="https://libguides.law.cuny.edu/c.php?g=1062724&amp;p=7727797" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'GC'">
								<a href="https://libguides.gc.cuny.edu/access/interlibraryloan" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'GJ'">
								<a href="https://researchguides.journalism.cuny.edu/center/collection#s-lg-box-31603267" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'HC'">
								<a href="https://library.hunter.cuny.edu/interlibrary-loan-policy" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'HO'">
								<a href="https://guides.hostos.cuny.edu/interlibrary" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'JJ'">
								<a href="https://lib.jjay.cuny.edu/libbasics/otherlibraries" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'KB'">
								<a href="https://kbcc-cuny.illiad.oclc.org/illiad/logon.html" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'LE'">
								<a href="https://lehman.edu/library/ill.php" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'LG'">
								<a href="https://lagcc-cuny.illiad.oclc.org/illiad/logon.html" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'ME'">
								<a href="https://mec-cuny.illiad.oclc.org/illiad/FAQ.html" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'NC'">
								<a href="https://guttman-cuny.libinsight.com/ill-request" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'NY'">
								<a href="https://library.citytech.cuny.edu/services/interlibraryLoan/index.html" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'QB'">
								<a href="https://qcc.libguides.com/interlibraryloan" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'QC'">
								<a href="https://qc.illiad.oclc.org/illiad/logon.html" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'SI'">
								<a href="https://library.csi.cuny.edu/ill" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:when test="$campus_code = 'YC'">
								<a href="https://www.york.cuny.edu/library/interlibrary-loan" target="_blank">Visit our ILL page</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="https://cuny.edu/libraries/services/interlibrary-loan/" target="_blank">Visit our ILL page</a>
							</xsl:otherwise>
						</xsl:choose>
						 to explore this option.
					</p>
				</xsl:if>

				<!-- Success message for conversions -->
				<xsl:if test="notification_data/request/status_note_display = 'Converted to resource sharing request'">
					<p>You will receive another notification once the item becomes available or if we need additional information from you.</p>
				</xsl:if>

				<xsl:call-template name="lastFooter" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>