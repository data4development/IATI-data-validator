<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

  <xsl:include href="../../lib/functx.xslt"/>
  <xsl:include href="iati/identifiers.xslt"/>
  <xsl:include href="iati/sectors.xslt"/>
  <xsl:include href="iati/geo.xslt"/>
  <xsl:include href="iati/language.xslt"/>
  <xsl:include href="iati/traceability.xslt"/>
  <xsl:include href="iati/information.xslt"/>
  <xsl:include href="iati/financial.xslt"/>
  <xsl:include href="iati/results.xslt"/>
  <xsl:include href="minbuza/traceability.xslt"/>
  <xsl:include href="minbuza/results.xslt"/>
  <xsl:output indent="yes"/>

  <xsl:template match="iati-activity">
    <xsl:copy>
      <xsl:attribute name="iati-me:id">
        <xsl:value-of select="iati-identifier"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:apply-templates select="." mode="rules"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:apply-templates select="." mode="rules"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="rules">
  </xsl:template>

</xsl:stylesheet>
