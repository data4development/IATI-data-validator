<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:template match="iati-activity" mode="rules" priority="4.1">
  
    <xsl:if test="not(./@xml:lang) and descendant::narrative[not(@xml:lang)]">
      <me:feedback type="warning" class="information" id="4.1.1">
        <me:src ref="iati" href="http://iatistandard.org/202/activity-standard/iati-activities/iati-activity/#iati-activities-iati-activity-xml-lang"/>
        <me:message>The activity should specify a default language, or the language should be specified for each narrative element.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="title" mode="rules" priority="4.2">
    <!-- Get all activity titles -->
    <xsl:variable name="activity-titles" select="//title/(narrative|text())"/>
        
    <!--todo: check if this works...-->
    <xsl:if test="count((narrative|text()) = $activity-titles) > 1">
      <me:feedback type="info" class="information" id="4.2.1">
        <me:src ref="practice" versions="any"/>
        <me:message>The activity title occurs more than once in the data.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="title" mode="rules" priority="4.3">
    <xsl:call-template name="narrative_content_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="itemname" select="name(.)"/>
      <xsl:with-param name="idclass">4.3</xsl:with-param>
    </xsl:call-template>    
  </xsl:template>

  <xsl:template match="description" mode="rules" priority="4.4">
    <xsl:call-template name="narrative_content_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="itemname" select="name(.)"/>
      <xsl:with-param name="idclass">4.4</xsl:with-param>
    </xsl:call-template>    
  </xsl:template>
  
  <xsl:template name="narrative_content_check">
    <xsl:param name="item"/>
    <xsl:param name="itemname"/>
    <xsl:param name="idclass"/>
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="starts-with($iati-version, '2.')
      and (not($item/narrative) or not($item/narrative[functx:trim(.)!='']))">
      <me:feedback type="warning" class="information" id="{$idclass}.1">
        <me:src ref="iati" versions="2.x"/>
        <me:message>The {$itemname} has no narrative content.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="starts-with($iati-version, '1.')
      and (functx:trim(string($item))='')">
      <me:feedback type="warning" class="information" id="{$idclass}.2">
        <me:src ref="iati" versions="1.x"/>
        <me:message>The {$itemname} has no narrative content.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>
