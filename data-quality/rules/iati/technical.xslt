<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:template match="iati-activities|iati-organisations" mode="rules" priority="10.1">
    <xsl:if test="doc-available('/workspace/tmp/iatifeedback/'||$filename)">
      <xsl:apply-templates select="doc('/workspace/tmp/iatifeedback/'||$filename)/*" mode="technical"/>  
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-file-with-schema-errors" mode="technical">
    <me:feedback type="critical" class="iati" id="0.3.1">
      <me:src ref="iati" versions="any"/>
      <me:message>The file is not a valid IATI file. The raw feedback from schema validation:

<xsl:choose>
  <xsl:when test="unparsed-text-available('/workspace/tmp/xmlschemalog/' || $filename)">{unparsed-text("/workspace/tmp/xmlschemalog/" || $filename)}</xsl:when>
  <xsl:otherwise>(not possible to present, maybe a binary file)</xsl:otherwise>
</xsl:choose></me:message>
    </me:feedback>
  </xsl:template>
  
  <xsl:template match="recovered-iati-file-with-schema-errors" mode="technical">
    <me:feedback type="critical" class="iati" id="0.4.1">
      <me:src ref="iati" versions="any"/>
      <me:message>The file is not a valid XML. A recovered version also is not a valid IATI file.
The raw feedback from xmllint:

<xsl:choose>
  <xsl:when test="unparsed-text-available('/workspace/tmp/xmltestlog/' || $filename)">{unparsed-text("/workspace/tmp/xmltestlog/" || $filename)}</xsl:when>
  <xsl:otherwise>(not possible to present, maybe a binary file)</xsl:otherwise>
</xsl:choose>
        
The raw feedback from schema validation:
        
<xsl:choose>
  <xsl:when test="unparsed-text-available('/workspace/tmp/xmlschemalog/' || $filename)">{unparsed-text("/workspace/tmp/xmlschemalog/" || $filename)}</xsl:when>
  <xsl:otherwise>(not possible to present, maybe a binary file)</xsl:otherwise>
</xsl:choose>
      </me:message>
    </me:feedback>
  </xsl:template>

  <xsl:template match="recovered-iati-file" mode="technical">
    <me:feedback type="critical" class="iati" id="0.5.1">
      <me:src ref="iati" versions="any"/>
      <me:message>The file is not a valid XML. A recovered version does form a valid IATI file, but may not contain all information. The raw feedback from xmllint:
        
<xsl:choose>
  <xsl:when test="unparsed-text-available('/workspace/tmp/xmltestlog/' || $filename)">{unparsed-text("/workspace/tmp/xmltestlog/" || $filename)}</xsl:when>
  <xsl:otherwise>(not possible to present, maybe a binary file)</xsl:otherwise>
</xsl:choose>
      </me:message>
    </me:feedback>
  </xsl:template>
</xsl:stylesheet>  
