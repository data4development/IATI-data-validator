<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  expand-text="yes">

  <xsl:template match="indicator" mode="rules" priority="8.1">
  
    <xsl:if test="not(period)">
      <me:feedback type="warning" class="performance" id="8.1.2">
        <me:src ref="practice" versions="any"/>
        <me:message>The result indicator has no periods with target or actual values.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="@measure='2' and (ancestor::result/@aggregation-status=true())">
      <me:feedback type="warning" class="performance" id="8.1.3">
        <me:src ref="practice" versions="any"/>
        <me:message>The indicator is a percentage, but part of a result marked as suitable for aggregation.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="not(baseline)">
      <me:feedback type="warning" class="performance" id="8.1.4">
        <me:src ref="practice" versions="any"/>
        <me:message>The result indicator has no baseline.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="result" mode="rules" priority="8.2">
    
    <xsl:if test="not(@aggregation-status)">
      <me:feedback type="warning" class="performance" id="8.2.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The result has no aggregation status flag.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="result[@aggregation-status]" mode="rules" priority="8.8">
    
    <xsl:if test="not(@aggregation-status castable as xs:boolean)">
      <me:feedback type="error" class="performance" id="8.8.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The result aggregation status is not a valid boolean value.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="indicator/reference" mode="rules" priority="8.3">
    
    <xsl:if test="@vocabulary='99' and (not(@indicator-uri) or @indicator-uri='')">
      <me:feedback type="info" class="performance" id="8.3.1">
        <me:src ref="practice" versions="any"/>
        <me:message>The result indicator URI is missing for the organisation-specific indicator.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="baseline" mode="rules" priority="8.4">
    <!-- todo: better way to determine start/end year? look at actual before planned -->
    <xsl:variable name="start-year" select="xs:integer(format-date(ancestor::iati-acitivity/activity-date[@type=('1','2')][1]/@iso-date,'[Y]'))"/>
    <xsl:variable name="end-year" select="xs:integer(format-date(ancestor::iati-acitivity/activity-date[@type=('3','4')][1]/@iso-date,'[Y]'))"/>
    
    <xsl:choose>
      <xsl:when test="not(@year castable as xs:integer)">
        <me:feedback type="danger" class="performance" id="8.4.4">
          <me:src ref="practice" versions="any"/>
          <me:message>The year for the baseline is not a number.</me:message>
        </me:feedback>
      </xsl:when>
      
      <xsl:when test="(xs:integer(@year) lt 1950) or (xs:integer(@year) gt 2050)">
        <me:feedback type="danger" class="performance" id="8.4.1">
          <me:src ref="practice" versions="any"/>
          <me:message>The year for the baseline is not realistic.</me:message>
        </me:feedback>
      </xsl:when>
      
      <xsl:when test="xs:integer(@year) lt $start-year - 5">
        <me:feedback type="warning" class="performance" id="8.4.2">
          <me:src ref="practice" versions="any"/>
          <me:message>The year for the baseline is more than 5 years before the start date of the activity.</me:message>
        </me:feedback>
      </xsl:when>
      
      <xsl:when test="xs:integer(@year) gt $end-year">
        <me:feedback type="warning" class="performance" id="8.4.3">
          <me:src ref="practice" versions="any"/>
          <me:message>The year for the baseline is after the end date of the activity.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
        
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="baseline/@value|target/@value|actual/@value" mode="rules" priority="8.5">
    <xsl:if test="ancestor::result/@aggregation-status castable as xs:boolean and xs:boolean(ancestor::result/@aggregation-status) and not(. castable as xs:decimal)">
      <me:feedback type="danger" class="performance" id="8.5.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The {name(..)} value is not a number but the indicator is part of a result that can be aggregated.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>    

  <xsl:template match="period" mode="rules" priority="8.6">
    
    <xsl:if test="period-start/@iso-date gt period-end/@iso-date">
      <me:feedback type="danger" class="performance" id="8.6.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The start of the period is after the end of the period.</me:message>
      </me:feedback>
    </xsl:if>
    
<!--    <xsl:if test="not(target or actual)">
      <me:feedback type="warning" class="performance" id="8.1.1">
        <me:src ref="practice" versions="any"/>
        <me:message>The result indicator has a period without a target or actual value.</me:message>
      </me:feedback>
    </xsl:if>
-->    
    <xsl:if test="not(target)">
      <me:feedback type="info" class="performance" id="8.6.2">
        <me:src ref="iati" versions="any"/>
        <me:message>The target for the period is missing.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="not(actual)">
      <me:feedback type="info" class="performance" id="8.6.3">
        <me:src ref="iati" versions="any"/>
        <me:message>The actual for the period is missing.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="baseline/location|target/location|actual/location" mode="rules" priority="8.7">
    
    <xsl:if test="not(@ref=ancestor::iati-activity/location/@ref)">
      <me:feedback type="danger" class="performance" id="8.7.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The location that the indicator references is not specified in this activity.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>
