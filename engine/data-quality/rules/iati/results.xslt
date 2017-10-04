<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="indicator" mode="rules" priority="8.1">

  <xsl:if test="period[not(target or actual)]">
    <iati-me:feedback type="warning" class="results" id="8.1.1">
      <iati-me:message>The result indicator has a period without a target or actual value.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
