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
  
  <xsl:template match="me:feedback[starts-with(@id, '9.')]">
    <xsl:param name="code"/>
    <xsl:text> (code "{$code}")</xsl:text>
  </xsl:template>
  
  <xsl:template name="show-organisation">
    <xsl:choose>
      <xsl:when test="@ref">{@ref}</xsl:when>
      <xsl:otherwise>"{functx:trim(string-join((text(),narrative[1]/.),''))}"</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="reporting-org" mode="context">
    <xsl:text>In {name(.)} </xsl:text><xsl:call-template name="show-organisation"/>
  </xsl:template>

  <xsl:template match="participating-org" mode="context">
    <xsl:text>In {name(.)} </xsl:text><xsl:call-template name="show-organisation"/> (role {@role})
  </xsl:template>

  <xsl:template match="transaction" mode="context">
    <xsl:text>In </xsl:text>
    <xsl:choose>
      <xsl:when test="transaction-type/@code='1'">incoming funds</xsl:when>
      <xsl:when test="transaction-type/@code='2'">(outgoing) commitment</xsl:when>
      <xsl:when test="transaction-type/@code='3'">disbursement</xsl:when>
      <xsl:when test="transaction-type/@code='4'">expenditure</xsl:when>
      <xsl:when test="transaction-type/@code='11'">incoming commitment</xsl:when>
      <xsl:otherwise>transaction</xsl:otherwise>
    </xsl:choose>
    <xsl:text> of {transaction-date/@iso-date}</xsl:text>
  </xsl:template>

  <xsl:template match="transaction-date" mode="context">
    <xsl:text>In </xsl:text>
    <xsl:choose>
      <xsl:when test="../transaction-type/@code='1'">incoming funds</xsl:when>
      <xsl:when test="../transaction-type/@code='2'">(outgoing) commitment</xsl:when>
      <xsl:when test="../transaction-type/@code='3'">disbursement</xsl:when>
      <xsl:when test="../transaction-type/@code='4'">expenditure</xsl:when>
      <xsl:when test="../transaction-type/@code='11'">incoming commitment</xsl:when>
      <xsl:otherwise>transaction</xsl:otherwise>
    </xsl:choose>
    <xsl:text> of {@iso-date}</xsl:text>
  </xsl:template>
  
  <xsl:template match="budget" mode="context">
    In the budget of <xsl:value-of select="period-start/@iso-date"/> to <xsl:value-of select="period-end/@iso-date"/>
  </xsl:template>

  <xsl:template match="provider-org|receiver-org" mode="context">
    <xsl:text>In transaction of {../transaction-date/@iso-date} for {name(.)} </xsl:text><xsl:call-template name="show-organisation"/>
  </xsl:template>

  <xsl:template match="document-link" mode="context">
    For the document "<xsl:apply-templates select="title"/>"
    <xsl:apply-templates select="me:feedback">
      <xsl:with-param name="code" select="@format"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="result|indicator" mode="context">
    For the {name(.)} "<xsl:apply-templates select="title"/>"
  </xsl:template>

  <xsl:template match="baseline|indicator/reference|indicator/description|result/description" mode="context">
    For the {name(..)} "<xsl:apply-templates select="../title"/>"
  </xsl:template>
  
  <xsl:template match="location/description" mode="context">
    For the {name(..)} "<xsl:apply-templates select="../name"/>"
  </xsl:template>
  
  <xsl:template match="target|actual" mode="context">
    For the indicator "<xsl:apply-templates select="../../title"/>" in the period {../period-start/@iso-date} to {../period-end/@iso-date} for {name(.)} value {@value}
  </xsl:template>
  
  <xsl:template match="period" mode="context">
    In the indicator "<xsl:apply-templates select="../title"/>" in the period {period-start/@iso-date} to {period-end/@iso-date}
  </xsl:template>

  <xsl:template match="target/location|actual/location" mode="context">
    For the {name(..)} location of the indicator "<xsl:apply-templates select="../../../title"/>" in the period {../../period-start/@iso-date} to {../../period-end/@iso-date}
  </xsl:template>

  <xsl:template match="other-identifier" mode="context">
    For the {name(.)} {@ref} of type {@type}
  </xsl:template>
  
  <xsl:template match="@*|node()" mode="context">
  </xsl:template>
    
</xsl:stylesheet>
