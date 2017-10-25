<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<xsl:variable name="mime-types" select="doc('../../lib/mime-types.xml')//code"/>

<xsl:template match="document-link" mode="rules" priority="6.1">
  <xsl:variable name="unlikelyformats" select="(
    'application/javascript'
    )"/>

  <xsl:if test="@format=$unlikelyformats">
    <iati-me:feedback type="info" class="information" id="6.1.1">
      <iati-me:src ref="practice" versions="any"/>
      <iati-me:message>The document format is specified as <code><xsl:value-of select="@format"/></code>.
      This is an unlikely format for a document.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="not(@format = $mime-types)">
    <iati-me:feedback type="warning" class="information" id="6.1.2">
      <iati-me:src ref="iati-doc" versions="2.x" href="http://www.iana.org/assignments/media-types/media-types.xhtml"/>
      <iati-me:message>The document format <code><xsl:value-of select="@format"/></code>
        is not a known media type.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="iati-activity" mode="rules" priority="6.2">
  <xsl:if test="not(activity-status)">
    <iati-me:feedback type="danger" class="information" id="6.2.1">
      <iati-me:src ref="iati-xsd" versions="any"/>
      <iati-me:message>The activity has no activity status code.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="not(sector) and not(transaction/sector)">
    <iati-me:feedback type="warning" class="information" id="6.2.2">
      <iati-me:src ref="iati-doc" versions="any"/>
      <iati-me:message>The activity has no sector classification information for either
      the activity or the transactions.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="sector and not(sector/@vocabulary='1' or not(sector/@vocabulary))">
    <iati-me:feedback type="warning" class="information" id="6.2.2">
      <iati-me:src ref="minbuza" versions="any"/>
      <iati-me:message>The activity has no sector classification information for the OECD DAC
      sector vocabulary.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
