<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="iati-me xs"
  expand-text="yes">

  <xsl:import href="../lib/html/bootstrap.xslt"/>
  <xsl:variable name="meta" select="/me:meta"/>

  <xsl:template match="/" mode="html-head">
    <title>Data quality rules</title>
  </xsl:template>

  <xsl:template match="*" mode="navbar-brand">
    <div class="navbar-brand">DataWorkbench</div>
  </xsl:template>

  <xsl:template match="*" mode="navbar-links">
    <ul class="nav navbar-nav">
      <li class="active"><a href="#" class="active">Data quality rules</a></li>
    </ul>
  </xsl:template>

  <xsl:template match="/" mode="html-body">
    <div class="container-fluid" role="main">
      <table class="table">
        <xsl:for-each-group select="collection('../data-quality/rules/?select=*.xslt;recurse=yes')//me:feedback"
          group-by="@class">
          <xsl:sort select="count($meta//me:category[@class=current-grouping-key()]/preceding-sibling::*)"/>
          <tr>
            <th colspan="5">
              <h2><xsl:value-of select="$meta//me:category[@class=current-grouping-key()]/me:title"/></h2>
            </th>
          </tr>
          <tr>
            <th>ID</th>
            <th>Severity</th>
            <th>Description</th>
            <th>Source(s)</th>
            <th>Context (XPath match)</th>
            <th>Pattern (XPath test)</th>
          </tr>
          <xsl:apply-templates select="current-group()">
            <xsl:sort select="@id" data-type="number"/>
          </xsl:apply-templates>
        </xsl:for-each-group>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="me:feedback">
    <tr>
      <xsl:variable name="type" select="@type"/>
      <td><a name="{@id}"></a><xsl:value-of select="@id"/></td>
      <td class="{@type}"><xsl:value-of select="$meta//me:severity[@type=$type]"/></td>
      <td><xsl:apply-templates select="me:message"/></td>
      <td><ul><xsl:apply-templates select="me:src"/></ul></td>
      <td><code><xsl:value-of select="ancestor::xsl:template[1]/@match"/></code></td>
      <td><code><xsl:value-of select="ancestor::*[local-name(.)=('if','when')][1]/@test"/></code></td>
    </tr>
  </xsl:template>

  <xsl:template match="code">
    <xsl:copy copy-namespaces="no"><xsl:value-of select="(text(),'X')[1]"/></xsl:copy>
  </xsl:template>
  <xsl:template match="me:src">
    <li><span title="{$meta//me:source[@id=current()/@ref]}">{@ref}
    <xsl:if test="@versions">
      ({@versions})
    </xsl:if></span></li>
  </xsl:template>
</xsl:stylesheet>
