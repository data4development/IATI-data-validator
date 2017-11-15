<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="iati-activity" mode="rules" priority="101.1">
  
    <xsl:if test="not(result)">
      <me:feedback type="info" class="results" id="108.1.1">
        <me:src ref="minbuza"/>
        <me:message>An activity should contain a results section.</me:message>
        <me:description></me:description>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="not(sector[@vocabulary=('1','')] or sector[not(@vocabulary)])">
      <me:feedback type="danger" class="information" id="102.1.1">
        <me:src ref="minbuza" versions="any"/>
        <me:message>The activity has no sector classification information for the OECD DAC sector vocabulary.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="not(recipient-region/@vocabulary=('1','') or not(recipient-region/@vocabulary))">
      <me:feedback type="danger" class="information" id="103.1.1">
        <me:src ref="minbuza" versions="any"/>
        <me:message>The region vocabulary code must be either omitted or at least one region vocabulary value must be 1 (OECD/DAC).</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>
