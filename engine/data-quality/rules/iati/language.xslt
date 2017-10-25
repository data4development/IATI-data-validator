<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<!-- Get all activity titles -->
<xsl:variable name="activity-titles" select="//title/(narrative|text())"/>

<xsl:template match="iati-activity" mode="rules" priority="4.1">

  <xsl:if test="not(./@xml:lang) and descendant::narrative[not(@xml:lang)]">
    <iati-me:feedback type="warning" class="language" id="4.1.1">
      <iati-me:src ref="iati" href="http://iatistandard.org/202/activity-standard/iati-activities/iati-activity/#iati-activities-iati-activity-xml-lang"/>
      <iati-me:message>Specify a default language for the activity OR specify the language for
      each narrative element.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="title" mode="rules" priority="4.2">

  <xsl:if test="count((narrative|text()) = $activity-titles) > 1">
    <iati-me:feedback type="info" class="language" id="4.2.1">
      <iati-me:src ref="practice" versions="any"/>
      <iati-me:message>The same activity title is occurring more than once in the data set.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
