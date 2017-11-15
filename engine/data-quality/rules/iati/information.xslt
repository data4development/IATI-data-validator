<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<xsl:variable name="mime-types" select="doc('../../lib/mime-types.xml')//code"/>

<xsl:template match="document-link" mode="rules" priority="6.1">
  <xsl:if test="@format=('application/javascript')">
    <me:feedback type="info" class="information" id="6.1.1">
      <me:src ref="practice" versions="any"/>
      <me:message>The document format is specified as <code><xsl:value-of select="@format"/></code>. This is an unlikely format for a document.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:if test="not(@format = $mime-types)">
    <me:feedback type="warning" class="information" id="6.1.2">
      <me:src ref="iati-doc" versions="2.x" href="http://www.iana.org/assignments/media-types/media-types.xhtml"/>
      <me:message>The document format <code><xsl:value-of select="@format"/></code> is not a known media type.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:if test="not(title/narrative)">
    <me:feedback type="warning" class="information" id="6.1.3">
      <me:src ref="iati-doc" versions="2.x"/>
      <me:message>The document title narrative is missing.</me:message>
    </me:feedback>
  </xsl:if>
  
  <xsl:next-match/>
</xsl:template>

<xsl:template match="iati-activity" mode="rules" priority="6.2">
  <xsl:if test="not(activity-status)">
    <me:feedback type="danger" class="information" id="6.2.1">
      <me:src ref="iati-xsd" versions="any"/>
      <me:message>The activity has no activity status code.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:if test="not(sector) and not(transaction/sector)">
    <me:feedback type="warning" class="information" id="6.2.2">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>The activity has no sector classification information for either the activity or the transactions.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:if test="not(policy-marker)">
    <me:feedback type="warning" class="information" id="6.2.3">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>No policy markers have been specified.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
