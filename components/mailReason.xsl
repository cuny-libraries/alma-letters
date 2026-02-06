<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Forcing title case on patron names (which come in in ALL CAPS from the SIS) -->
<xsl:template name="title-case">
    <xsl:param name="text"/>
    <xsl:param name="delimiter" select="' '"/>
    
    <xsl:choose>
        <xsl:when test="contains($text, $delimiter)">
            <!-- Handle first word -->
            <xsl:call-template name="capitalize-word">
                <xsl:with-param name="word" select="substring-before($text, $delimiter)"/>
            </xsl:call-template>
            <xsl:value-of select="$delimiter"/>
            <!-- Recursively handle remaining words -->
            <xsl:call-template name="title-case">
                <xsl:with-param name="text" select="substring-after($text, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <!-- Handle single word -->
            <xsl:call-template name="capitalize-word">
                <xsl:with-param name="word" select="$text"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Helper template to capitalize a single word -->
<xsl:template name="capitalize-word">
    <xsl:param name="word"/>
    <xsl:value-of select="concat(
        translate(substring($word, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
        translate(substring($word, 2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')
    )"/>
</xsl:template>

<!-- Usage in your mailReason.xsl template -->
<xsl:template name="toWhomIsConcerned">
    <xsl:for-each select="notification_data">
        <p id="mailReason">
            <xsl:choose>
                <xsl:when test="receivers/receiver/user/first_name != ''">
                    Hi, 
                    <xsl:call-template name="title-case">
                        <xsl:with-param name="text" select="receivers/receiver/user/first_name"/>
                    </xsl:call-template>! 👋
                </xsl:when>
                <xsl:otherwise>
                    Hi, there! 👋
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:for-each>
</xsl:template>

<!-- Unified item display template -->
<xsl:template name="displayItem">
	<xsl:param name="showDueDate" select="'true'" />
	<xsl:param name="showOverdueStatus" select="'false'" />
	<xsl:param name="showDescription" select="'true'" />
	<xsl:param name="showLibrary" select="'false'" />
	<xsl:param name="showFines" select="'false'" />
	<xsl:param name="showLoanDate" select="'false'" />
	<xsl:param name="showBarcode" select="'false'" />
	<xsl:param name="showCallNumber" select="'false'" />
	<xsl:param name="showItemNumber" select="'false'" />
	<xsl:param name="showEquipmentNote" select="'false'" />
	<xsl:param name="showPublisher" select="'false'" />
	<xsl:param name="showISBN" select="'false'" />
	<xsl:param name="showUserNote" select="'false'" />
	<xsl:param name="containerClass" select="'info-box'" />
	
	<div>
		<xsl:attribute name="class"><xsl:value-of select="$containerClass"/></xsl:attribute>
		
		<h3>
			<xsl:value-of select="title"/>
			<xsl:if test="normalize-space(author) != ''">
				 by <xsl:value-of select="author"/>
			</xsl:if>
		</h3>
		
		<p>
			<xsl:if test="$showDescription = 'true' and normalize-space(description) != ''">
				<strong>Description:</strong> <xsl:value-of select="description"/><br />
			</xsl:if>
			
			<xsl:if test="$showLoanDate = 'true' and normalize-space(loan_date) != ''">
				<strong>Loan Date:</strong> <xsl:value-of select="loan_date"/><br />
			</xsl:if>
			
			<xsl:if test="$showDueDate = 'true' and normalize-space(new_due_date_str) != ''">
				<strong>Due Date:</strong> 
				<xsl:choose>
					<xsl:when test="$showOverdueStatus = 'true'">
						<span class="status-overdue"><xsl:value-of select="new_due_date_str"/></span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="new_due_date_str"/>
					</xsl:otherwise>
				</xsl:choose>
				<br />
			</xsl:if>
			
			<xsl:if test="$showBarcode = 'true' and normalize-space(barcode) != ''">
				<strong>Barcode:</strong> <xsl:value-of select="barcode"/><br />
			</xsl:if>
			
			<xsl:if test="$showCallNumber = 'true' and normalize-space(call_number) != ''">
				<strong>Call Number:</strong> <xsl:value-of select="call_number"/>
			</xsl:if>
			
			<xsl:if test="$showItemNumber = 'true' and normalize-space(alternative_call_number) != ''">
				<xsl:if test="$showCallNumber = 'true' and normalize-space(call_number) != ''"> | </xsl:if>
				<strong>Item Number:</strong> <xsl:value-of select="alternative_call_number"/>
			</xsl:if>
			
			<xsl:if test="($showCallNumber = 'true' and normalize-space(call_number) != '') or ($showItemNumber = 'true' and normalize-space(alternative_call_number) != '')">
				<br />
			</xsl:if>
			
			<xsl:if test="$showLibrary = 'true' and normalize-space(library_name) != ''">
				<strong>Library:</strong> <xsl:value-of select="library_name"/><br />
			</xsl:if>
			
			<xsl:if test="$showPublisher = 'true'">
				<xsl:if test="normalize-space(../phys_item_display/publisher) != '' or normalize-space(../phys_item_display/publication_date) != ''">
					<xsl:if test="normalize-space(../phys_item_display/publisher) != ''">
						Published by <xsl:value-of select="../phys_item_display/publisher"/>
						<xsl:if test="normalize-space(../phys_item_display/publication_date) != ''">, <xsl:value-of select="../phys_item_display/publication_date"/></xsl:if>
					</xsl:if>
					<xsl:if test="normalize-space(../phys_item_display/publisher) = '' and normalize-space(../phys_item_display/publication_date) != ''">
						Published <xsl:value-of select="../phys_item_display/publication_date"/>
					</xsl:if>
					<br />
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$showISBN = 'true' and normalize-space(../phys_item_display/isbn) != ''">
				<strong>ISBN:</strong> <xsl:value-of select="../phys_item_display/isbn"/><br />
			</xsl:if>
			
			<xsl:if test="$showUserNote = 'true' and normalize-space(../request/note) != ''">
				<strong>Your note:</strong> <xsl:value-of select="../request/note"/><br />
			</xsl:if>
			
			<!-- Equipment responsibility note -->
			<xsl:if test="$showEquipmentNote = 'true'">
				<xsl:call-template name="checkEquipmentResponsibility" />
			</xsl:if>
			
			<!-- Fines and fees display -->
			<xsl:if test="$showFines = 'true' and fines_fees_list/user_fines_fees">
				<strong>Fines and Fees:</strong>
				<ul style="margin-top:-15px;margin-left:-15px;">
					<xsl:for-each select="fines_fees_list/user_fines_fees">
						<li>
							<strong><xsl:value-of select="fine_fee_type_display"/></strong>: 
							$<xsl:value-of select="fine_fee_ammount/normalized_sum"/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
		</p>
	</div>
</xsl:template>

<!-- Calculate days overdue template -->
<xsl:template name="calculateDaysOverdue">
	<xsl:param name="due-date" />
	<xsl:param name="current-date" />
	
	<!-- Parse current date (MM/DD/YYYY format) -->
	<xsl:variable name="current-month" select="substring-before($current-date, '/')" />
	<xsl:variable name="current-day" select="substring-before(substring-after($current-date, '/'), '/')" />
	<xsl:variable name="current-year" select="substring-after(substring-after($current-date, '/'), '/')" />
	
	<!-- Parse due date - extract first 10 characters (MM/DD/YYYY) and ignore time -->
	<xsl:variable name="due-date-only" select="substring($due-date, 1, 10)" />
	<xsl:variable name="due-month" select="substring-before($due-date-only, '/')" />
	<xsl:variable name="due-day" select="substring-before(substring-after($due-date-only, '/'), '/')" />
	<xsl:variable name="due-year" select="substring-after(substring-after($due-date-only, '/'), '/')" />
	
	<!-- Convert to days since epoch for calculation -->
	<xsl:variable name="current-days" select="
		($current-year * 365) + 
		floor($current-year div 4) - floor($current-year div 100) + floor($current-year div 400) +
		floor(($current-month - 1) * 30.44) + 
		$current-day
	" />
	
	<xsl:variable name="due-days" select="
		($due-year * 365) + 
		floor($due-year div 4) - floor($due-year div 100) + floor($due-year div 400) +
		floor(($due-month - 1) * 30.44) + 
		$due-day
	" />
	
	<xsl:value-of select="$current-days - $due-days" />
</xsl:template>

<!-- Get campus-specific URLs -->
<xsl:template name="getCampusSpecificURL">
	<xsl:param name="urlType" /> <!-- 'hours' or 'ill' -->
	<xsl:param name="campusCode" />
	
	<!-- If campusCode not provided, try to derive it from context -->
	<xsl:variable name="rawCampusCode">
		<xsl:choose>
			<xsl:when test="$campusCode != ''">
				<xsl:value-of select="$campusCode" />
			</xsl:when>
			<xsl:when test="/notification_data/organization_unit/code">
				<xsl:value-of select="/notification_data/organization_unit/code" />
			</xsl:when>
			<xsl:when test="notification_data/organization_unit/code">
				<xsl:value-of select="notification_data/organization_unit/code" />
			</xsl:when>
			<xsl:otherwise>XX</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Extract campus code: if starts with 0, take last 2 chars; otherwise take first 2 -->
	<xsl:variable name="actualCampusCode">
		<xsl:choose>
			<xsl:when test="starts-with($rawCampusCode, '0')">
				<xsl:value-of select="substring($rawCampusCode, string-length($rawCampusCode) - 1)" />
			</xsl:when>
			<xsl:when test="string-length($rawCampusCode) >= 2">
				<xsl:value-of select="substring($rawCampusCode, 1, 2)" />
			</xsl:when>
			<xsl:otherwise>XX</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="$urlType = 'hours'">
			<xsl:choose>
				<xsl:when test="$actualCampusCode = 'BB'">https://library.baruch.cuny.edu/about/hours/</xsl:when>
				<xsl:when test="$actualCampusCode = 'BC'">https://library.brooklyn.cuny.edu/library/about/hours/</xsl:when>
				<xsl:when test="$actualCampusCode = 'BM'">https://www.bmcc.cuny.edu/library/hours/</xsl:when>
				<xsl:when test="$actualCampusCode = 'BX'">https://bcc-cuny.libcal.com/hours</xsl:when>
				<xsl:when test="$actualCampusCode = 'CC'">https://library.ccny.cuny.edu/hours</xsl:when>
				<xsl:when test="$actualCampusCode = 'CL'">https://libguides.law.cuny.edu/c.php?g=1062724&amp;p=7727796</xsl:when>
				<xsl:when test="$actualCampusCode = 'GC'">https://gc-cuny.libcal.com/hours</xsl:when>
				<xsl:when test="$actualCampusCode = 'GJ'">https://researchguides.journalism.cuny.edu/center/welcome#s-lg-box-31003663</xsl:when>
				<xsl:when test="$actualCampusCode = 'HC'">https://library.hunter.cuny.edu/hours</xsl:when>
				<xsl:when test="$actualCampusCode = 'HO'">https://hostos.libcal.com/hours/</xsl:when>
				<xsl:when test="$actualCampusCode = 'JJ'">https://lib.jjay.cuny.edu/plan-your-visit/hours</xsl:when>
				<xsl:when test="$actualCampusCode = 'KB'">https://library.kbcc.cuny.edu/calendar</xsl:when>
				<xsl:when test="$actualCampusCode = 'LE'">https://www.lehman.edu/library/hours-contact.php</xsl:when>
				<xsl:when test="$actualCampusCode = 'LG'">https://library.laguardia.edu/hours/</xsl:when>
				<xsl:when test="$actualCampusCode = 'ME'">https://mec-cuny.libcal.com/hours/</xsl:when>
				<xsl:when test="$actualCampusCode = 'NC'">https://guttman.cuny.edu/library/</xsl:when>
				<xsl:when test="$actualCampusCode = 'NY'">https://libcal.citytech.cuny.edu/</xsl:when>
				<xsl:when test="$actualCampusCode = 'QB'">https://qcc.libguides.com/hours</xsl:when>
				<xsl:when test="$actualCampusCode = 'QC'">https://qc-cuny.libcal.com/hours</xsl:when>
				<xsl:when test="$actualCampusCode = 'SI'">https://library.csi.cuny.edu/about/hours</xsl:when>
				<xsl:when test="$actualCampusCode = 'YC'">https://www.york.cuny.edu/library/about/library-hours</xsl:when>
				<xsl:otherwise>https://cuny.edu/libraries/</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="$urlType = 'ill'">
			<xsl:choose>
				<xsl:when test="$actualCampusCode = 'BB'">https://library.baruch.cuny.edu/help/interlibrary-loan/</xsl:when>
				<xsl:when test="$actualCampusCode = 'BC'">https://libguides.brooklyn.cuny.edu/interlibraryloan</xsl:when>
				<xsl:when test="$actualCampusCode = 'BM'">https://www.bmcc.cuny.edu/library/services/borrow-renew-request/interlibrary-loan/</xsl:when>
				<xsl:when test="$actualCampusCode = 'BX'">https://www.bcc.cuny.edu/library/library-faculty/library-faculty-illiad/</xsl:when>
				<xsl:when test="$actualCampusCode = 'CC'">https://library.ccny.cuny.edu/services/ILL</xsl:when>
				<xsl:when test="$actualCampusCode = 'CL'">https://libguides.law.cuny.edu/c.php?g=1062724&amp;p=7727797</xsl:when>
				<xsl:when test="$actualCampusCode = 'GC'">https://libguides.gc.cuny.edu/access/interlibraryloan</xsl:when>
				<xsl:when test="$actualCampusCode = 'GJ'">https://researchguides.journalism.cuny.edu/center/collection#s-lg-box-31603267</xsl:when>
				<xsl:when test="$actualCampusCode = 'HC'">https://library.hunter.cuny.edu/interlibrary-loan-policy</xsl:when>
				<xsl:when test="$actualCampusCode = 'HO'">https://guides.hostos.cuny.edu/interlibrary</xsl:when>
				<xsl:when test="$actualCampusCode = 'JJ'">https://lib.jjay.cuny.edu/libbasics/otherlibraries</xsl:when>
				<xsl:when test="$actualCampusCode = 'KB'">https://kbcc-cuny.illiad.oclc.org/illiad/logon.html</xsl:when>
				<xsl:when test="$actualCampusCode = 'LE'">https://lehman.edu/library/ill.php</xsl:when>
				<xsl:when test="$actualCampusCode = 'LG'">https://lagcc-cuny.illiad.oclc.org/illiad/logon.html</xsl:when>
				<xsl:when test="$actualCampusCode = 'ME'">https://mec-cuny.illiad.oclc.org/illiad/FAQ.html</xsl:when>
				<xsl:when test="$actualCampusCode = 'NC'">https://guttman-cuny.libinsight.com/ill-request</xsl:when>
				<xsl:when test="$actualCampusCode = 'NY'">https://library.citytech.cuny.edu/services/interlibraryLoan/index.html</xsl:when>
				<xsl:when test="$actualCampusCode = 'QB'">https://qcc.libguides.com/interlibraryloan</xsl:when>
				<xsl:when test="$actualCampusCode = 'QC'">https://qc.illiad.oclc.org/illiad/logon.html</xsl:when>
				<xsl:when test="$actualCampusCode = 'SI'">https://library.csi.cuny.edu/ill</xsl:when>
				<xsl:when test="$actualCampusCode = 'YC'">https://www.york.cuny.edu/library/interlibrary-loan</xsl:when>
				<xsl:otherwise>https://cuny.edu/libraries/services/interlibrary-loan/</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>https://cuny.edu/libraries/</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Check equipment responsibility -->
<xsl:template name="checkEquipmentResponsibility">
	<xsl:variable name="campusCode" select="substring(/notification_data/organization_unit/code, 1, 2)" />
	<xsl:variable name="isEquipment">
		<xsl:choose>
			<!-- Hunter College equipment locations -->
			<xsl:when test="$campusCode = 'HC' and (location_code='AVDC' or location_code='AVDH' or location_code='AVDW' or location_code='CAT' or location_code='SWIVC' or location_code='TAIPC' or location_code='TAIPCS')">1</xsl:when>
			<!-- Bronx Community College equipment locations -->
			<xsl:when test="$campusCode = 'BX' and (location_code='EQUIP' or location_code='TECH' or location_code='AV')">1</xsl:when>
			<!-- LaGuardia Community College equipment locations -->
			<xsl:when test="$campusCode = 'LG' and (location_code='MEDIA' or location_code='TECH' or location_code='EQUIP')">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:if test="$isEquipment = 1">
		<br /><strong>Equipment Responsibility:</strong> You are responsible for this equipment and its use as listed at: 
		<xsl:choose>
			<xsl:when test="$campusCode = 'HC'">
				<a href="https://library.hunter.cuny.edu/technology-loans" target="_blank">https://library.hunter.cuny.edu/technology-loans</a>
			</xsl:when>
			<xsl:when test="$campusCode = 'BX'">
				<a href="https://bcc-cuny.libguides.com/equipment" target="_blank">https://bcc-cuny.libguides.com/equipment</a>
			</xsl:when>
			<xsl:when test="$campusCode = 'LG'">
				<a href="https://library.laguardia.edu/technology" target="_blank">https://library.laguardia.edu/technology</a>
			</xsl:when> 
		</xsl:choose>
	</xsl:if>
</xsl:template>

<!-- Display overdue status with days calculation -->
<xsl:template name="displayOverdueStatus">
	<xsl:param name="dueDate" />
	<xsl:param name="currentDate" />
	<xsl:param name="showDaysOverdue" select="'false'" />
	
	<span class="status-overdue">
		<xsl:value-of select="$dueDate"/>
		<xsl:if test="$showDaysOverdue = 'true'">
			<xsl:variable name="daysOverdue">
				<xsl:call-template name="calculateDaysOverdue">
					<xsl:with-param name="due-date" select="$dueDate" />
					<xsl:with-param name="current-date" select="$currentDate" />
				</xsl:call-template>
			</xsl:variable>
			 (<xsl:value-of select="$daysOverdue" /> days overdue)
		</xsl:if>
	</span>
</xsl:template>

</xsl:stylesheet>