<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="iati-activity" mode="rules" priority="2.1">

  <!-- Check for multiple sector codes per vocabulary. -->
  <xsl:for-each-group select="sector" group-by="@vocabulary">
    <xsl:if test="count(current-group()) > 1">

      <xsl:if test="count(current-group()[not(@percentage)]) > 0">
        <iati-me:feedback type="danger" class="sectors" id="2.1.1">
          <iati-me:message>One or more sectors in vocabulary <code><xsl:value-of select="current-grouping-key()"/></code>
          have no percentage: <xsl:value-of select="current-group()[not(@percentage)]/@code" separator=", "/></iati-me:message>
        </iati-me:feedback>
      </xsl:if>

      <xsl:if test="sum(current-group()/@percentage) != 100">
        <iati-me:feedback type="danger" class="sectors" id="2.1.2">
          <iati-me:message>Percentages for sectors in vocabulary <code><xsl:value-of select="current-grouping-key()"/></code>
          don't add up to 100%.</iati-me:message>
        </iati-me:feedback>
      </xsl:if>

    </xsl:if>
  </xsl:for-each-group>

  <xsl:if test="count(sector)>0 and count(transaction/sector)>0">
    <iati-me:feedback type="info" class="sectors" id="2.1.3">
      <iati-me:src ref="iati" href="http://iatistandard.org/202/activity-standard/iati-activities/iati-activity/sector/#definition"/>
      <iati-me:message>You are using sectors in both the activity and transactions in the
      activity. You should only use them in one place.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>
</xsl:stylesheet>
