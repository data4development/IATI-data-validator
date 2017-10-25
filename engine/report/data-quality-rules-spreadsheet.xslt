<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:office="http://iati.me/office"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
  xmlns:calcext="urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"

  exclude-result-prefixes="iati-me office xs">

  <xsl:import href="../lib/office/spreadsheet.xslt"/>
  <xsl:variable name="meta" select="/iati-me:meta"/>

  <xsl:template match="*" mode="office-spreadsheet-table">
    <table:table table:name="Rules" table:style-name="ta1">
      <xsl:apply-templates select="collection('../data-quality/rules/?select=*.xslt;recurse=yes')//iati-me:feedback" mode="office-spreadsheet-row">
        <xsl:sort select="@id" data-type="number"/>
      </xsl:apply-templates>
    </table:table>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-row-header">
    <!-- First set column widths -->
    <table:table-column table:style-name="co1" table:default-cell-style-name="Default"/>
    <table:table-column table:style-name="co1" table:default-cell-style-name="Default"/>
    <table:table-column table:style-name="co1" table:default-cell-style-name="Default"/>
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

  <xsl:template match="Y" mode="office-spreadsheet-cells">
    <xsl:variable name="t"><iati-me:a>abc</iati-me:a><iati-me:b>aa</iati-me:b></xsl:variable>
    <xsl:apply-templates select="$t" mode="office-spreadsheet-cell"/>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-cells">
    <xsl:variable name="empty"><iati-me:x></iati-me:x></xsl:variable>
    <xsl:apply-templates select="@class" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="@id" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="$meta//iati-me:severity[@type=current()/@type]" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="(iati-me:message, $empty)[1]" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="(iati-me:description, $empty)[1]" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="ancestor::xsl:template[1]/@match" mode="office-spreadsheet-cell"/>
    <xsl:apply-templates select="ancestor::*[local-name(.)=('if','when')][1]/@test" mode="office-spreadsheet-cell"/>
  </xsl:template>

  <xsl:template match="/" mode="html-body">
    <div class="container-fluid" role="main">
      <table class="table">
        <xsl:for-each-group select="collection('../data-quality/rules/?select=*.xslt;recurse=yes')//iati-me:feedback"
          group-by="@class">
          <xsl:sort select="count($meta//iati-me:category[@class=current-grouping-key()]/preceding-sibling::*)"/>
          <xsl:apply-templates select="current-group()">
            <xsl:sort select="@id" data-type="number"/>
          </xsl:apply-templates>
        </xsl:for-each-group>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="iati-me:feedback" mode="never">
    <tr>
      <xsl:variable name="type" select="@type"/>
      <td><a name="{@id}"></a><xsl:value-of select="@id"/></td>
      <td class="{@type}"><xsl:value-of select="$meta//iati-me:severity[@type=$type]"/></td>
      <td><code><xsl:value-of select="ancestor::xsl:if[1]/@test"/></code></td>
    </tr>
  </xsl:template>

  <xsl:template match="code">
    <xsl:copy copy-namespaces="no"><xsl:value-of select="(text(),'X')[1]"/></xsl:copy>
  </xsl:template>
</xsl:stylesheet>
