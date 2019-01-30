<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:office="http://iati.me/office"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
  xmlns:calcext="urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"

  expand-text="yes"
  exclude-result-prefixes="me office xs">

  <xsl:import href="../lib/office/spreadsheet.xslt"/>
  <xsl:variable name="meta" select="/me:meta"/>

  <xsl:template match="*" mode="office-spreadsheet-table">
    <table:table table:name="Rules" table:style-name="ta1">
      <xsl:apply-templates select="collection('../data-quality/rules/?select=*.xslt;recurse=yes')//me:feedback" mode="office-spreadsheet-row">
        <xsl:sort select="@id" data-type="number"/>
      </xsl:apply-templates>
    </table:table>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-row-header">
    <!-- First set column widths -->
    <table:table-column table:style-name="co1" table:default-cell-style-name="Default"/>
    <table:table-column table:style-name="co1" table:default-cell-style-name="Default"/>
    <table:table-column table:style-name="co1" table:default-cell-style-name="Default"/>
    <table:table-column table:style-name="co2" table:default-cell-style-name="Default"/>
    <table:table-column table:style-name="co4" table:default-cell-style-name="Default"/>
    <table:table-column table:style-name="co4" table:default-cell-style-name="Default"/>
    <table:table-column table:style-name="co4" table:default-cell-style-name="Default"/>
    <table:table-column table:style-name="co4" table:default-cell-style-name="Default"/>
    <!-- Next set the column headings -->
    <table:table-row table:style-name="ro1">
      <table:table-cell table:style-name="Heading" office:value-type="string" calcext:value-type="string">
          <text:p>Class</text:p>
      </table:table-cell>
      <table:table-cell table:style-name="Heading" office:value-type="string" calcext:value-type="string">
          <text:p>ID</text:p>
      </table:table-cell>
      <table:table-cell table:style-name="Heading" office:value-type="string" calcext:value-type="string">
          <text:p>Severity</text:p>
      </table:table-cell>
      <table:table-cell table:style-name="Heading" office:value-type="string" calcext:value-type="string">
        <text:p>Rule set(s)</text:p>
      </table:table-cell>
      <table:table-cell table:style-name="Heading" office:value-type="string" calcext:value-type="string">
          <text:p>Message</text:p>
      </table:table-cell>
      <table:table-cell table:style-name="Heading" office:value-type="string" calcext:value-type="string">
          <text:p>Description</text:p>
      </table:table-cell>
      <table:table-cell table:style-name="Heading" office:value-type="string" calcext:value-type="string">
          <text:p>Context (XPath)</text:p>
      </table:table-cell>
      <table:table-cell table:style-name="Heading" office:value-type="string" calcext:value-type="string">
          <text:p>Test (XPath)</text:p>
      </table:table-cell>
    </table:table-row>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-cells">
    <xsl:variable name="empty"><me:x></me:x></xsl:variable>
    <xsl:variable name="t"><xsl:apply-templates select="me:src" mode="ruleset-list"/></xsl:variable>
    <xsl:variable name="rulesetseverities"><xsl:value-of select="$t/me:t" separator=", "/></xsl:variable>
    
    <xsl:apply-templates select="@class" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="@id" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="$meta//me:severity[@type=current()/@type]" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="$rulesetseverities" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="(me:message, $empty)[1]" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="(me:description, $empty)[1]" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="(ancestor::xsl:template[1]/@match, $empty)[1]" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="ancestor::*[local-name(.)=('if','when')][1]/@test" mode="office-spreadsheet-cell"/>
  </xsl:template>

  <xsl:template match="me:src" mode="ruleset-list">
    <me:t>{@ref}<xsl:if test="@versions and @versions!='any'">:{@versions}</xsl:if><xsl:if test="@type"> ({$meta//me:severity[@type=current()/@type]})</xsl:if></me:t>
  </xsl:template>

  <xsl:template match="code">
    <xsl:copy copy-namespaces="no"><xsl:value-of select="(text(),'X')[1]"/></xsl:copy>
  </xsl:template>
</xsl:stylesheet>
