<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <!-- Get all activity titles -->
  <xsl:template match="iati-activities" mode="rules" priority="900.1">
  
    <xsl:if test="(//title,//description,//name)[text()[normalize-space(.)!='']] 
      and (//title,//description,//name)[narrative/text()[normalize-space(.)!='']]">
      <me:feedback type="warning" class="iati" id="900.1.1">
        <me:src ref="practice"/>
        <me:message>The dataset seems to contain activities in both IATI 1.0x and 2.0x formats.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:next-match/>
  </xsl:template>

</xsl:stylesheet>
