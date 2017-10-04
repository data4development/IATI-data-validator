<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="document-link" mode="rules" priority="6.1">
  <xsl:variable name="unlikelyformats" select="(
    'application/javascript'
    )"/>

  <xsl:if test="@format=$unlikelyformats">
    <iati-me:feedback type="info" class="information" id="6.1.1">
      <iati-me:message>The document type is specified as <code><xsl:value-of select="@format"/></code>.
      This is an unlikely format for a document.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="iati-activity" mode="rules" priority="6.2">
  <xsl:if test="not(activity-status)">
    <iati-me:feedback type="danger" class="information" id="6.2.1">
      <iati-me:message>The activity has no activity status code.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="not(sector) and not(transaction/sector)">
    <iati-me:feedback type="warning" class="information" id="6.2.2">
      <iati-me:message>The activity has no sector classification information for either
      the activity or the transactions.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="sector and not(sector/@vocabulary='1' or not(sector/@vocabulary))">
    <iati-me:feedback type="info" class="information" id="6.2.2">
      <iati-me:message>The activity has no sector classification information for the OECD DAC
      sector vocabulary.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
