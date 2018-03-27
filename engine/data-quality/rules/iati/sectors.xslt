<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="iati-activity" mode="rules" priority="2.1">

    <!-- Check for multiple sector codes per vocabulary. -->
    <!-- todo: handle the case of no vocabulary and vocabulary="1" as a single group-->
    <xsl:for-each-group select="sector" group-by="@vocabulary">
      <xsl:if test="count(current-group()) > 1">
        <xsl:choose>
          <xsl:when test="count(current-group()[not(@percentage)]) > 0">
            <me:feedback type="danger" class="sectors" id="2.1.1">
              <me:src ref="iati-doc" versions="any"/>
              <me:message>One or more sectors in vocabulary <code><xsl:value-of select="current-grouping-key()"/></code> have no percentage: <xsl:value-of select="current-group()[not(@percentage)]/@code" separator=", "/></me:message>
            </me:feedback>
          </xsl:when>

          <xsl:when test="abs(sum(current-group()/@percentage)-100)>0.01">
            <me:feedback type="danger" class="sectors" id="2.1.2">
              <me:src ref="iati-doc" versions="any"/>
              <me:message>Percentages for sectors in vocabulary <code><xsl:value-of select="current-grouping-key()"/></code> don't add up to 100%.</me:message>
            </me:feedback>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each-group>

    <xsl:if test="count(sector)>0 and count(transaction/sector)>0">
      <me:feedback type="info" class="sectors" id="2.1.3">
        <me:src ref="iati" href="http://iatistandard.org/202/activity-standard/iati-activities/iati-activity/sector/#definition"/>
        <me:message>You are using sectors in both the activity and transactions in the activity. You should only use them in one place.</me:message>
      </me:feedback>
    </xsl:if>



    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="sector[@vocabulary=('1','')]" mode="rules" priority="2.2">
    <xsl:if test="not(matches(@code, '^[0-9]{5}$'))">
      <me:feedback type="danger" class="sectors" id="2.2.1">
        <me:src ref="iati"/>
        <me:message>The OECD DAC sector code is not a 5-digit code.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>
</xsl:stylesheet>
