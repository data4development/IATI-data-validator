<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  xmlns:iwb="http://iati.me/office"

  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
  xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
  xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
  xmlns:math="http://www.w3.org/1998/Math/MathML"
  xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
  xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
  xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
  xmlns:ooo="http://openoffice.org/2004/office"
  xmlns:ooow="http://openoffice.org/2004/writer"
  xmlns:oooc="http://openoffice.org/2004/calc"
  xmlns:dom="http://www.w3.org/2001/xml-events"
  xmlns:xforms="http://www.w3.org/2002/xforms"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:rpt="http://openoffice.org/2005/report"
  xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:grddl="http://www.w3.org/2003/g/data-view#"
  xmlns:tableooo="http://openoffice.org/2009/table"
  xmlns:drawooo="http://openoffice.org/2010/draw"
  xmlns:calcext="urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0"
  xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0"
  xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0"
  xmlns:formx="urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0"
  xmlns:css3t="http://www.w3.org/TR/css3-text/"
  office:version="1.2"
  office:mimetype="application/vnd.oasis.opendocument.spreadsheet"

  expand-text="yes"
  exclude-result-prefixes="functx iwb">

  <xsl:import href="../functx.xslt"/>

  <xsl:template match="/" mode="office-spreadsheet-meta">
    <office:meta>
        <meta:creation-date><xsl:value-of select="current-dateTime()"/></meta:creation-date>
        <dc:date><xsl:value-of select="current-dateTime()"/></dc:date>
        <meta:generator>IATI Data Validator</meta:generator>
        <meta:document-statistic meta:table-count="1" meta:cell-count="7" meta:object-count="0"/>
    </office:meta>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-table">
    <xsl:param name="table-structure" tunnel="yes"/>
    <table:table table:name="{$table-structure/table-structure/@name}" 
                 table:style-name="{($table-structure/table-structure/@table-style, 'ta1')[1]}">
      <xsl:apply-templates select="*" mode="office-spreadsheet-row"/>
    </table:table>
  </xsl:template>

  <xsl:template match="*" mode="table-column">
    <table:table-column table:style-name="{(@column-style, 'co1')[1]}" 
                        table:default-cell-style-name="{(@cell-style, 'Default')[1]}"/>
  </xsl:template>

  <xsl:template match="*" mode="table-header-cell">
    <table:table-cell table:style-name="{('Heading')[1]}" 
                      office:value-type="{('string')[1]}" 
                      calcext:value-type="{('string')[1]}">
      <text:p>{./text()}</text:p>
    </table:table-cell>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-row">
    <xsl:param name="table-structure" tunnel="yes"/>
    <xsl:if test="position()=1">
      <!-- First set column widths -->
      <xsl:apply-templates select="$table-structure//column" mode="table-column"/>
      <!-- Next set the column headings -->
      <table:table-row table:style-name="{($table-structure/table-header/@row-style, 'ro1')[1]}">
        <xsl:apply-templates select="$table-structure/table-header/column" mode="table-header-cell"/>
      </table:table-row>
    </xsl:if>
    <table:table-row table:style-name="ro1">
      <xsl:apply-templates select="." mode="office-spreadsheet-cells"/>
    </table:table-row>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-cells">
    <xsl:variable name="t"><iwb:a>abc</iwb:a><iwb:b>def</iwb:b><iwb:iso-date>2017-10-04</iwb:iso-date><iwb:d>0</iwb:d></xsl:variable>
    <xsl:apply-templates select="$t" mode="office-spreadsheet-cell"/>
  </xsl:template>

  <xsl:template match="*[local-name()=('date', 'iso-date', 'value-date')]" mode="office-spreadsheet-cell">
    <table:table-cell office:value-type="date" calcext:value-type="date" office:date-value="{.}" table:style-name="ce1"/>
  </xsl:template>

  <xsl:template match="*|@*|text()" mode="office-spreadsheet-cell">
    <table:table-cell office:value-type="string" calcext:value-type="string">
      <text:p><xsl:value-of select="normalize-space(xsd:string(.))"/></text:p>
    </table:table-cell>
  </xsl:template>

  <xsl:template match="/" mode="office-spreadsheet">
    <office:document office:version="1.2" office:mimetype="application/vnd.oasis.opendocument.spreadsheet">
        <xsl:apply-templates select="." mode="office-spreadsheet-meta"/>
        <office:settings>
            <config:config-item-set config:name="ooo:configuration-settings">
                <config:config-item config:name="SyntaxStringRef" config:type="short">7</config:config-item>
                <config:config-item config:name="IsDocumentShared" config:type="boolean">false</config:config-item>
                <config:config-item config:name="LoadReadonly" config:type="boolean">false</config:config-item>
                <config:config-item config:name="AllowPrintJobCancel" config:type="boolean">true</config:config-item>
                <config:config-item config:name="UpdateFromTemplate" config:type="boolean">true</config:config-item>
                <config:config-item config:name="IsKernAsianPunctuation" config:type="boolean">false</config:config-item>
                <config:config-item config:name="EmbedFonts" config:type="boolean">false</config:config-item>
                <config:config-item config:name="IsSnapToRaster" config:type="boolean">false</config:config-item>
                <config:config-item config:name="RasterResolutionX" config:type="int">1000</config:config-item>
                <config:config-item config:name="RasterResolutionY" config:type="int">1000</config:config-item>
                <config:config-item config:name="HasSheetTabs" config:type="boolean">true</config:config-item>
                <config:config-item config:name="IsRasterAxisSynchronized" config:type="boolean">true</config:config-item>
                <config:config-item config:name="ShowPageBreaks" config:type="boolean">true</config:config-item>
                <config:config-item config:name="ShowGrid" config:type="boolean">true</config:config-item>
                <config:config-item config:name="ShowNotes" config:type="boolean">true</config:config-item>
                <config:config-item config:name="SaveVersionOnClose" config:type="boolean">false</config:config-item>
                <config:config-item config:name="GridColor" config:type="long">12632256</config:config-item>
                <config:config-item config:name="RasterIsVisible" config:type="boolean">false</config:config-item>
                <config:config-item config:name="IsOutlineSymbolsSet" config:type="boolean">true</config:config-item>
                <config:config-item config:name="ShowZeroValues" config:type="boolean">true</config:config-item>
                <config:config-item config:name="LinkUpdateMode" config:type="short">3</config:config-item>
                <config:config-item config:name="RasterSubdivisionX" config:type="int">1</config:config-item>
                <config:config-item config:name="HasColumnRowHeaders" config:type="boolean">true</config:config-item>
                <config:config-item config:name="RasterSubdivisionY" config:type="int">1</config:config-item>
                <config:config-item config:name="AutoCalculate" config:type="boolean">true</config:config-item>
                <config:config-item config:name="ApplyUserData" config:type="boolean">true</config:config-item>
                <config:config-item config:name="CharacterCompressionType" config:type="short">0</config:config-item>
            </config:config-item-set>
        </office:settings>
        <office:scripts>
            <office:script script:language="ooo:Basic">
                <ooo:libraries xmlns:ooo="http://openoffice.org/2004/office" xmlns:xlink="http://www.w3.org/1999/xlink"/>
            </office:script>
        </office:scripts>
        <office:font-face-decls>
            <style:font-face style:name="Liberation Sans" svg:font-family="'Liberation Sans'" style:font-family-generic="swiss" style:font-pitch="variable"/>
            <style:font-face style:name="DejaVu Sans" svg:font-family="'DejaVu Sans'" style:font-family-generic="system" style:font-pitch="variable"/>
            <style:font-face style:name="Droid Sans Fallback" svg:font-family="'Droid Sans Fallback'" style:font-family-generic="system" style:font-pitch="variable"/>
            <style:font-face style:name="FreeSans" svg:font-family="FreeSans" style:font-family-generic="system" style:font-pitch="variable"/>
        </office:font-face-decls>
        <office:styles>
            <style:default-style style:family="table-cell">
                <style:paragraph-properties style:tab-stop-distance="12.5mm"/>
                <style:text-properties
                    style:font-name="Liberation Sans"
                    fo:language="en"
                    fo:country="IE"
                    style:font-name-asian="DejaVu Sans"
                    style:language-asian="zh"
                    style:country-asian="CN"
                    style:font-name-complex="DejaVu Sans"
                    style:language-complex="hi"
                    style:country-complex="IN"/>
            </style:default-style>
            <number:number-style style:name="N0">
                <number:number number:min-integer-digits="1"/>
            </number:number-style>
            <style:style style:name="Default" style:family="table-cell">
                <style:text-properties
                    style:font-name-asian="Droid Sans Fallback"
                    style:font-family-asian="'Droid Sans Fallback'"
                    style:font-family-generic-asian="system"
                    style:font-pitch-asian="variable"
                    style:font-name-complex="FreeSans"
                    style:font-family-complex="FreeSans"
                    style:font-family-generic-complex="system"
                    style:font-pitch-complex="variable"/>
            </style:style>
            <style:style style:name="Heading" style:family="table-cell" style:parent-style-name="Default">
                <style:text-properties fo:color="#000000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="bold"/>
            </style:style>
            <style:style style:name="Heading_20_1" style:display-name="Heading 1" style:family="table-cell" style:parent-style-name="Heading">
                <style:text-properties fo:color="#000000" fo:font-size="18pt" fo:font-style="normal" fo:font-weight="normal"/>
            </style:style>
            <style:style style:name="Heading_20_2" style:display-name="Heading 2" style:family="table-cell" style:parent-style-name="Heading">
                <style:text-properties fo:color="#000000" fo:font-size="12pt" fo:font-style="normal" fo:font-weight="normal"/>
            </style:style>
            <style:style style:name="Text" style:family="table-cell" style:parent-style-name="Default"/>
            <style:style style:name="Note" style:family="table-cell" style:parent-style-name="Text">
                <style:table-cell-properties fo:background-color="#ffffcc" style:diagonal-bl-tr="none" style:diagonal-tl-br="none" fo:border="0.74pt solid #808080"/>
                <style:text-properties fo:color="#333333" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
            </style:style>
            <style:style style:name="Footnote" style:family="table-cell" style:parent-style-name="Text">
                <style:text-properties fo:color="#808080" fo:font-size="10pt" fo:font-style="italic" fo:font-weight="normal"/>
            </style:style>
            <style:style style:name="Status" style:family="table-cell" style:parent-style-name="Default"/>
            <style:style style:name="Good" style:family="table-cell" style:parent-style-name="Status">
                <style:table-cell-properties fo:background-color="#ccffcc"/>
                <style:text-properties fo:color="#006600" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
            </style:style>
            <style:style style:name="Neutral" style:family="table-cell" style:parent-style-name="Status">
                <style:table-cell-properties fo:background-color="#ffffcc"/>
                <style:text-properties fo:color="#996600" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
            </style:style>
            <style:style style:name="Bad" style:family="table-cell" style:parent-style-name="Status">
                <style:table-cell-properties fo:background-color="#ffcccc"/>
                <style:text-properties fo:color="#cc0000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
            </style:style>
            <style:style style:name="Warning" style:family="table-cell" style:parent-style-name="Status">
                <style:text-properties fo:color="#cc0000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
            </style:style>
            <style:style style:name="Error" style:family="table-cell" style:parent-style-name="Status">
                <style:table-cell-properties fo:background-color="#cc0000"/>
                <style:text-properties fo:color="#ffffff" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="bold"/>
            </style:style>
            <style:style style:name="Accent" style:family="table-cell" style:parent-style-name="Default">
                <style:text-properties fo:color="#000000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="bold"/>
            </style:style>
            <style:style style:name="Accent_20_1" style:display-name="Accent 1" style:family="table-cell" style:parent-style-name="Accent">
                <style:table-cell-properties fo:background-color="#000000"/>
                <style:text-properties fo:color="#ffffff" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
                <style:text-properties fo:color="#ffffff" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
            </style:style>
            <style:style style:name="Accent_20_2" style:display-name="Accent 2" style:family="table-cell" style:parent-style-name="Accent">
                <style:table-cell-properties fo:background-color="#808080"/>
            </style:style>
            <style:style style:name="Accent_20_3" style:display-name="Accent 3" style:family="table-cell" style:parent-style-name="Accent">
                <style:table-cell-properties fo:background-color="#dddddd"/>
            </style:style>
        </office:styles>
        <office:automatic-styles>
            <style:style style:name="co1" style:family="table-column">
                <style:table-column-properties fo:break-before="auto" style:column-width="25mm"/>
            </style:style>
            <style:style style:name="co2" style:family="table-column">
                <style:table-column-properties fo:break-before="auto" style:column-width="50mm"/>
            </style:style>
            <style:style style:name="co3" style:family="table-column">
                <style:table-column-properties fo:break-before="auto" style:column-width="75mm"/>
            </style:style>
            <style:style style:name="co4" style:family="table-column">
                <style:table-column-properties fo:break-before="auto" style:column-width="100mm"/>
            </style:style>
            <style:style style:name="co6" style:family="table-column">
                <style:table-column-properties fo:break-before="auto" style:column-width="150mm"/>
            </style:style>
            <style:style style:name="ro1" style:family="table-row">
                <style:table-row-properties style:row-height="4.52mm" fo:break-before="auto" style:use-optimal-row-height="true"/>
            </style:style>
            <style:style style:name="ta1" style:family="table" style:master-page-name="Default">
                <style:table-properties table:display="true" style:writing-mode="lr-tb"/>
            </style:style>
            <number:percentage-style style:name="N11">
                <number:number number:decimal-places="2" loext:min-decimal-places="2" number:min-integer-digits="1"/>
                <number:text>%</number:text>
            </number:percentage-style>
            <number:date-style style:name="N37" number:automatic-order="true">
              <number:year number:style="long"/>
              <number:text>-</number:text>
              <number:month number:style="long"/>
              <number:text>-</number:text>
              <number:day number:style="long"/>
            </number:date-style>
            <style:style style:name="ce1" style:family="table-cell" style:parent-style-name="Default" style:data-style-name="N37"/>
            <style:style style:name="ce2" style:family="table-cell" style:parent-style-name="Default" style:data-style-name="N11"/>
        </office:automatic-styles>
        <office:body>

            <office:spreadsheet>
              <xsl:variable name="table">
                <xsl:apply-templates select="." mode="office-spreadsheet-table"/>
              </xsl:variable>

              <table:calculation-settings table:automatic-find-labels="false" table:use-regular-expressions="false" table:use-wildcards="true"/>
              <xsl:copy-of select="$table"/>
              <table:named-expressions/>
              <table:database-ranges>
                <table:database-range table:name="{$table/table:table/@table:name}"
                  table:target-range-address="Sheet1.A1:Sheet1.{iwb:columnName(count($table[1]/table:table/table:table-column))}{count(.)+1}"
                  table:display-filter-buttons="true"/>
              </table:database-ranges>
            </office:spreadsheet>
        </office:body>
    </office:document>
  </xsl:template>

  <xsl:function name="iwb:columnName" as="xsd:string">
    <xsl:param name="i" as="xsd:integer"/>
    <xsl:choose>
      <xsl:when test="$i>0">
        <xsl:value-of select="concat(iwb:columnName($i idiv 26),
          ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')[$i mod 26])"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>
