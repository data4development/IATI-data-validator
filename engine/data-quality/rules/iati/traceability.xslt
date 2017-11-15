<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<xsl:template match="iati-activity" mode="rules" priority="5.1">
  <xsl:variable name="aid" select="iati-identifier/text()"/>

  <xsl:if test="(@hierarchy > 1) and not(related-activity[@type='1'])
    and not(//iati-activity/related-activity[@type='2' and @ref=$aid])">
    <me:feedback type="info" class="traceability" id="5.1.1">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>The activity is declared to be at hierarchical level <code><xsl:value-of select="@hierarchy"/></code> but there is no reference to a parent activity, and no other activity in the dataset refers to this activity as a child activity.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
