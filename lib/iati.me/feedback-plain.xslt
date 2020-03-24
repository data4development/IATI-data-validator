<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:functx="http://www.functx.com"
  xmlns:me="http://iati.me"
  expand-text="yes"
  exclude-result-prefixes="functx me">

  <xsl:variable name="feedback-meta" select="document('../../data-quality/meta.xml')/me:meta"/>
  
  <xsl:template match="@logo">
    <img class="icon" src="/img/{.}"/>
  </xsl:template>

  <xsl:template match="@href">
    <a target="_blank" class="icon glyphicon glyphicon-info-sign" href="{.}"/>
  </xsl:template>
  
  <xsl:template match="*" mode="get-text">
    <xsl:text>{functx:trim(./(narrative, text())[1])}</xsl:text>
  </xsl:template>

  <xsl:template match="*">
    <xsl:text>{functx:trim(./(narrative, text())[1])}</xsl:text>
  </xsl:template>
  
  <xsl:template name="show-organisation">
    <xsl:choose>
      <xsl:when test="../@ref">{../@ref}</xsl:when>
      <xsl:otherwise>"{functx:trim(string-join((../text(),../narrative[1]/.),''))}"</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Context information for reporting-org -->
  <xsl:template match="reporting-org/me:feedback" mode="context">
    <xsl:text>In {name(..)} </xsl:text><xsl:call-template name="show-organisation"/>
  </xsl:template>

  <!-- Context information for participating-org -->
  <xsl:template match="participating-org/me:feedback" mode="context">
    <xsl:text>In {name(..)} </xsl:text><xsl:call-template name="show-organisation"/> (role {../@role})
  </xsl:template>

  <!-- Context information for transactions -->
  <xsl:template match="transaction/me:feedback" mode="context">
    <xsl:text>In </xsl:text>
    <xsl:choose>
      <xsl:when test="../transaction-type/@code='1'">incoming funds</xsl:when>
      <xsl:when test="../transaction-type/@code='2'">(outgoing) commitment</xsl:when>
      <xsl:when test="../transaction-type/@code='3'">disbursement</xsl:when>
      <xsl:when test="../transaction-type/@code='4'">expenditure</xsl:when>
      <xsl:when test="../transaction-type/@code='11'">incoming commitment</xsl:when>
      <xsl:otherwise>transaction</xsl:otherwise>
    </xsl:choose>
    <xsl:text> of {../transaction-date/@iso-date}</xsl:text>
  </xsl:template>

  <!-- Context information for budget -->
  <xsl:template match="budget/me:feedback" mode="context">
    In the budget of <xsl:value-of select="period-start/@iso-date"/> to <xsl:value-of select="period-end/@iso-date"/>
  </xsl:template>

  <!-- Context information for provider-org and receiver-org in transactions -->
  <xsl:template match="provider-org/me:feedback|receiver-org/me:feedback" mode="context">
    <xsl:text>In transaction of {../../transaction-date/@iso-date} for {name(..)} </xsl:text><xsl:call-template name="show-organisation"/>
  </xsl:template>

  <!-- Context information for participating-org -->
  <xsl:template match="document-link/me:feedback" mode="context">
    <xsl:text>For the document</xsl:text> 
    <xsl:apply-templates select="../title"/>
  </xsl:template>

  <xsl:template match="result/me:feedback|indicator/me:feedback" mode="context">
    For the {name(..)} "<xsl:apply-templates select="../title"/>"
  </xsl:template>

  <xsl:template match="baseline/me:feedback|indicator/reference/me:feedback|indicator/description/me:feedback|result/description/me:feedback" mode="context">
    For the {name(../..)} "<xsl:apply-templates select="../../title"/>"
  </xsl:template>
  
  <xsl:template match="location/description/me:feedback" mode="context">
    For the {name(../..)} "<xsl:apply-templates select="../../name"/>"
  </xsl:template>
  
  <xsl:template match="target/me:feedback|actual/me:feedback" mode="context">
    For the indicator "<xsl:apply-templates select="../../../title"/>" in the period {../../period-start/@iso-date} to {../../period-end/@iso-date}
  </xsl:template>
  
  <xsl:template match="period/me:feedback" mode="context">
    In the indicator "<xsl:apply-templates select="../../title"/>" in the period {../period-start/@iso-date} to {../period-end/@iso-date}
  </xsl:template>

  <xsl:template match="target/location/me:feedback|actual/location/me:feedback" mode="context">
    For the {name(../..)} location of the indicator "<xsl:apply-templates select="../../../../title"/>" in the period {../../../period-start/@iso-date} to {../../../period-end/@iso-date}
  </xsl:template>

  <xsl:template match="other-identifier/me:feedback" mode="context">
    For the {name(..)} {../@ref} of type {../@type}
  </xsl:template>
  
  <xsl:template match="related-activity/me:feedback" mode="context">
    For the {name(..)} {../@ref}
  </xsl:template>

  <xsl:template match="@*|node()" mode="context">
  </xsl:template>
    
</xsl:stylesheet>
