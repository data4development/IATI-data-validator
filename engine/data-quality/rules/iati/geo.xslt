<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<xsl:template match="iati-activity" mode="rules" priority="3.1">

  <xsl:if test="count(recipient-country|recipient-region) > 1">
    <!-- the sum of percentages should be 100, but rounding errors occur -->
    <xsl:if test="abs(sum((recipient-country|recipient-region)/@percentage)-100)>0.01">
      <me:feedback type="danger" class="geo" id="3.1.1">
        <me:src ref="iati-doc" versions="2.x"/>
        <me:message>Percentages for recipient-country and recipient-region don't add up
        to 100%.</me:message>
      </me:feedback>
    </xsl:if>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>
</xsl:stylesheet>
