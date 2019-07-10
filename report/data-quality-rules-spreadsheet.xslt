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
  <xsl:variable name="calls" select="collection('../data-quality/rules/?select=*.xslt;recurse=yes')//xsl:call-template"/>

  <xsl:template match="*" mode="office-spreadsheet-table">
    <xsl:variable name="rules">
      <xsl:apply-templates select="collection('../data-quality/rules/?select=*.xslt;recurse=yes')//me:feedback" mode="get-feedback-messages"/>
    </xsl:variable>
    <table:table table:name="Rules" table:style-name="ta1">
      <xsl:apply-templates select="$rules" mode="office-spreadsheet-row">
        <xsl:sort select="@id"/>
      </xsl:apply-templates>
    </table:table>
  </xsl:template>

  <xsl:template match="*[ancestor::xsl:template[1][@match]]" mode="get-feedback-messages">
    <xsl:variable name="empty"><me:x></me:x></xsl:variable>
    <xsl:variable name="t"><xsl:apply-templates select="me:src" mode="ruleset-list"/></xsl:variable>
    <xsl:variable name="rulesetseverities"><xsl:value-of select="$t/me:t" separator=", "/></xsl:variable>

    <rule class="{@class}"
          id="{@id}"
          rulesets="{$rulesetseverities}">
      <severities>{$meta//me:severity[@type=current()/@type]}</severities>
      <message>{(me:message, $empty)[1]}</message>
      <description>{(me:description, $empty)[1]}</description>
      <context>{(ancestor::xsl:template[1]/@match, $empty)[1]}</context>
      <test>{ancestor::*[local-name(.)=('if','when')][1]/@test}</test>
    </rule>    
  </xsl:template>

  <xsl:template match="*[ancestor::xsl:template[1][@name]]" mode="get-feedback-messages">
    <!-- these are named templates called by other matches -->
    <xsl:apply-templates select="$calls[@name=current()/ancestor::xsl:template/@name]" mode="get-feedback-calls">
      <xsl:with-param name="rule" select="."/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="get-feedback-calls">
    <xsl:param name="rule"/>
    <xsl:variable name="empty"><me:x></me:x></xsl:variable>
    <!-- construct an instance of a match -->
    <rule class="{me:param(., 'class')}"
          id="{replace($rule/@id, '\{\$idclass\}', me:param(., 'idclass'))}"
          rulesets="{me:param(., 'versions')}">
      <severities>{$meta//me:severity[@type=$rule/@type]}</severities>
      <message>{($rule/me:message, $empty)[1]}</message>
      <description>{($rule/me:description, $empty)[1]}</description>
      <context>{(ancestor::xsl:template[1]/@match, $empty)[1]}</context>
      <test>{$rule/ancestor::*[local-name(.)=('if','when')][1]/@test}</test>
    </rule>
  </xsl:template>

  <xsl:function name="me:param">
    <xsl:param name="call"/>
    <xsl:param name="item"/>
    <xsl:text>{$call/xsl:with-param[@name=$item]/text()}</xsl:text>
  </xsl:function>

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
    <xsl:apply-templates mode="office-spreadsheet-cell"
      select="(@class, @id, severities, @rulesets, message, description, context, test)"/>
  </xsl:template>

  <xsl:template match="me:src" mode="ruleset-list">
    <me:t>{@ref}<xsl:if test="@versions and @versions!='any'">:{@versions}</xsl:if><xsl:if test="@type"> ({$meta//me:severity[@type=current()/@type]})</xsl:if></me:t>
  </xsl:template>

  <xsl:template match="code">
    <xsl:copy copy-namespaces="no"><xsl:value-of select="(text(),'X')[1]"/></xsl:copy>
  </xsl:template>
</xsl:stylesheet>
