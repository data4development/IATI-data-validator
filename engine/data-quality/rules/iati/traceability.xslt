<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="iati-activity" mode="rules" priority="5.1">
  <xsl:variable name="aid" select="iati-identifier/text()"/>

  <xsl:if test="(@hierarchy > 1) and not(related-activity[@type='1'])
    and not(//iati-activity/related-activity[@type='2' and @ref=$aid])">
    <iati-me:feedback type="info" class="traceability" id="5.1.1">
      <iati-me:message>The activity is declared to be at hierarchical level
      <code><xsl:value-of select="@hierarchy"/></code> but there is no reference to
      a parent activity, and no other activity in the dataset refers to this
      activity as a child activity.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
