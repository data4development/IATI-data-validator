<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:include href="../../lib/functx.xslt"/>
  <xsl:include href="iati/codelists.xslt"/>
  <xsl:include href="iati/identifiers.xslt"/>
  <xsl:include href="iati/sectors.xslt"/>
  <xsl:include href="iati/geo.xslt"/>
  <xsl:include href="iati/language.xslt"/>
  <xsl:include href="iati/traceability.xslt"/>
  <xsl:include href="iati/information.xslt"/>
  <xsl:include href="iati/financial.xslt"/>
  <xsl:include href="iati/results.xslt"/>
  <xsl:include href="donors.xslt"/>

  <xsl:output indent="yes"/>

  <xsl:variable name="iati-version-valid"
    select="/*/@version=('1.01','1.02','1.03','1.04','1.05','2.01','2.02','2.03')"/>
  <xsl:variable name="iati-version">
    <xsl:choose>
      <xsl:when test="$iati-version-valid">{/*/@version}</xsl:when>
      <xsl:when test="starts-with(/*/@version, '1.')">1.05</xsl:when>
      <xsl:otherwise>2.03</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:if test="name(.)='iati-identifier'">
        <xsl:attribute name="me:id">{iati-identifier}</xsl:attribute>  
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:apply-templates select="." mode="rules"/>
      <xsl:apply-templates select="@*" mode="rules"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="rules">
  </xsl:template>

</xsl:stylesheet>
