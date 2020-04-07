<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  exclude-result-prefixes="xs"
  version="3.0"
  expand-text="yes">
  
  <xsl:param name="filename"/>
  
  <xsl:variable name="schemaVersion" select="doc('../data-quality/rules/iati.xslt')//xsl:variable[@name='schemaVersion']"/>
  
  <xsl:template match="/not-an-xml-file">
    <not-an-xml-file xmlns:me="http://iati.me" me:schemaVersion="{$schemaVersion}">
      <me:feedback type="critical" class="iati" id="0.1.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The file is not a proper XML file. The raw feedback from xmllint:

<xsl:choose>
  <xsl:when test="unparsed-text-available('/work/space/tmp/xmltestlog/' || $filename)">{unparsed-text("/work/space/tmp/xmltestlog/" || $filename)}</xsl:when>
  <xsl:otherwise>(not possible to present, maybe a binary file)</xsl:otherwise>
</xsl:choose></me:message>
      </me:feedback>
    </not-an-xml-file>
  </xsl:template>

  <xsl:template match="/not-an-iati-file">
    <not-an-iati-file xmlns:me="http://iati.me" me:schemaVersion="{$schemaVersion}">
      <me:feedback type="critical" class="iati" id="0.2.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The file is not an IATI file.</me:message>
      </me:feedback>
    </not-an-iati-file>
  </xsl:template>
  
</xsl:stylesheet>
