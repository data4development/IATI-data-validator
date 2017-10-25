<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  xmlns:iati-me="http://iati.me"
  expand-text="yes"
  exclude-result-prefixes="">

  <xsl:variable name="feedback-meta" select="document('../../data-quality/meta.xml')/iati-me:meta"/>

  <xsl:template match="@logo">
    <img class="icon" src="/img/{.}"/>
  </xsl:template>

  <xsl:template match="@href">
    <a target="_blank" class="icon glyphicon glyphicon-info-sign" href="{.}"/>
  </xsl:template>

  <xsl:template name="show-organisation">
    <xsl:choose>
      <xsl:when test="../@ref"><code>{../@ref}</code></xsl:when>
      <xsl:otherwise>"{functx:trim(string-join((../text(),../narrative[1]/.),''))}"</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Context information for reporting-org -->
  <xsl:template match="reporting-org/iati-me:feedback" mode="context">
    <xsl:variable name="ref">
    </xsl:variable>
    In <xsl:value-of select="name(..)"/>&#160;<xsl:call-template name="show-organisation"/>:
  </xsl:template>

  <!-- Context information for participating-org -->
  <xsl:template match="participating-org/iati-me:feedback" mode="context">
    In <xsl:value-of select="name(..)"/>&#160;<xsl:call-template name="show-organisation"/> (role <code><xsl:value-of select="../@role"/></code>):
  </xsl:template>

  <!-- Context information for transactions -->
  <xsl:template match="transaction/iati-me:feedback" mode="context">
    In
    <xsl:choose>
      <xsl:when test="../transaction-type/@code='1'">incoming funds</xsl:when>
      <xsl:when test="../transaction-type/@code='2'">(outgoing) commitment</xsl:when>
      <xsl:when test="../transaction-type/@code='3'">disbursement</xsl:when>
      <xsl:when test="../transaction-type/@code='4'">expenditure</xsl:when>
      <xsl:when test="../transaction-type/@code='11'">incoming commitment</xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
    transaction of <xsl:value-of select="../transaction-date/@iso-date"/>:
  </xsl:template>

  <!-- Context information for budget -->
  <xsl:template match="budget/iati-me:feedback" mode="context">
    In the budget of <xsl:value-of select="period-start/@iso-date"/> to <xsl:value-of select="period-end/@iso-date"/>:
  </xsl:template>

  <!-- Context information for provider-org and receiver-org in transactions -->
  <xsl:template match="provider-org/iati-me:feedback|receiver-org/iati-me:feedback" mode="context">
    In transaction of <xsl:value-of select="../../transaction-date/@iso-date"/> for <xsl:value-of select="name(..)"/>&#160;<xsl:call-template name="show-organisation"/>:
  </xsl:template>

  <!-- Context information for participating-org -->
  <xsl:template match="document-link/iati-me:feedback" mode="context">
    For the document <a href="{../@url}"><xsl:value-of select="functx:trim(../title/.)"/></a>:
  </xsl:template>

  <!-- Context information for result indicator -->
  <xsl:template match="indicator/iati-me:feedback" mode="context">
    For the indicator "<em><xsl:value-of select="functx:trim(../title/narrative[1])"/></em>":
  </xsl:template>

  <xsl:template match="@*|node()" mode="context">
  </xsl:template>

</xsl:stylesheet>
