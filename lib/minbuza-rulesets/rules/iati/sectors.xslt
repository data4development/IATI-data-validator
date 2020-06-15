<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:template match="iati-activity[sector]" mode="rules" priority="2.1">
    
    <!-- Check for percentages for multiple sector codes for the default vocabulary. -->    
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="sector[not(@vocabulary) or @vocabulary=('', '1')]"/>
      <xsl:with-param name="class">classifications</xsl:with-param>
      <xsl:with-param name="idclass">2.1</xsl:with-param>
      <xsl:with-param name="item">sector</xsl:with-param>
      <xsl:with-param name="items">sectors</xsl:with-param>
      <xsl:with-param name="vocabulary">1</xsl:with-param>
      <xsl:with-param name="href">activity-standard/iati-activities/iati-activity/sector/</xsl:with-param>
    </xsl:call-template>
    
    <!-- Check for multiple sector codes per vocabulary. -->
    <xsl:for-each-group select="sector" group-by="@vocabulary">
      <xsl:if test="not(current-grouping-key()=('', '1'))">
        <xsl:call-template name="percentage-checks">
          <xsl:with-param name="group" select="current-group()"/>
          <xsl:with-param name="class">classifications</xsl:with-param>
          <xsl:with-param name="idclass">2.1</xsl:with-param>
          <xsl:with-param name="item">sector</xsl:with-param>
          <xsl:with-param name="items">sectors</xsl:with-param>
          <xsl:with-param name="vocabulary" select="current-grouping-key()"/>
          <xsl:with-param name="href">activity-standard/iati-activities/iati-activity/sector/</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each-group>

<!-- TODO: overlaps with 6.2.2/6.6.2/6.7.2 -->
    <xsl:if test="count(sector)>0 and count(transaction/sector)>0">
      <me:feedback type="warning" class="classifications" id="2.1.3">
        <me:src ref="iati" versions="2.0x" href="me:iati-url('activity-standard/iati-activities/iati-activity/sector/')"/>
        <me:message>You are using sectors on both the activity and on the transaction level. You should only use them in one place.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
</xsl:stylesheet>  
