<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:variable name="org-id-prefixes" select="doc('../../lib/known-prefixes.xml')//code"/>
  <xsl:variable name="known-publisher-ids" select="doc('/home/data-quality/lib/known-publishers.xml')//code"/>
  <xsl:variable name="known-10x-ids" select="doc('/home/data-quality/lib/known-publishers-104.xml')//code"/>

  <xsl:template match="iati-identifier" mode="rules" priority="1.1">
  
    <!-- TODO: deal with renamed organisations (NL-1 XM-DAC-7) -->
    <xsl:if test="not(starts-with(., ../reporting-org/@ref))">
      <me:feedback type="warning" class="identifiers" id="1.1.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The activity identifier should begin with the organisation identifier of the reporting organisation</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="//iati-activity[iati-identifier=current()][2]">
      <me:feedback type="danger" class="identifiers" id="1.1.2">
        <me:src ref="iati" versions="any"/>
        <me:message>The activity identifier should not occur multiple times in the dataset.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test=". = ../reporting-org/@ref">
      <me:feedback type="danger" class="identifiers" id="1.1.3">
        <me:src ref="iati" versions="any"/>
        <me:message>The activity identifier cannot be the same as the organisation identifier of the reporting organisation.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="reporting-org|participating-org|provider-org|receiver-org" mode="rules" priority="1.2">
    <xsl:choose>
      <xsl:when test="not(@ref) and (@activity-id or @receiver-activity-id or @provider-activity-id)">
        <me:feedback type="info" class="identifiers" id="1.2.3">
          <me:src ref="iati" versions="any"/>
          <me:message>The activity identifier is given: the organisation identifier should occur too.</me:message>
        </me:feedback>
      </xsl:when>
  
      <xsl:when test="not(@ref)">
        <me:feedback type="info" class="identifiers" id="1.2.2">
          <me:src ref="iati" versions="any"/>
          <me:message>The organisation identifier is missing.</me:message>
        </me:feedback>      
      </xsl:when>
    </xsl:choose>
  
    <xsl:next-match/>
  </xsl:template>

  <!-- Checks on the identifiers of organisations or activities -->
  <xsl:template match="iati-identifier" mode="rules" priority="1.3">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="itemname">{name(.)}</xsl:with-param>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.3</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
  
  <xsl:template match="@provider-activity-id" mode="rules" priority="1.4">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="itemname">{name(.)}</xsl:with-param>
      <xsl:with-param name="class">financial</xsl:with-param>
      <xsl:with-param name="idclass">1.4</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
  
  <xsl:template match="@receiver-activity-id" mode="rules" priority="1.5">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="itemname">{name(.)}</xsl:with-param>
      <xsl:with-param name="class">financial</xsl:with-param>
      <xsl:with-param name="idclass">1.5</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
  
  <xsl:template match="other-identifier[@type='A3']/@ref" mode="rules" priority="1.6">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="itemname">{name(.)}</xsl:with-param>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.6</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
  
  <xsl:template match="@ref[not(name(..)=('location', 'transaction', 'other-identifier'))]" mode="rules" priority="1.7">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="itemname">{name(.)}</xsl:with-param>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.7</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
  
  <xsl:template name="identifier_check">
    <xsl:param name="item"/>
    <xsl:param name="itemname"/>
    <xsl:param name="class"/>
    <xsl:param name="idclass"/>
    
    <xsl:choose>
      <xsl:when test="functx:trim($item)=''">
        <me:feedback type="warning" class="{$class}" id="{$idclass}.7">
          <me:src ref="iati" versions="any"/>
          <me:message>The identifier <code>{$itemname}</code> has no value: it should be omitted if you don't have a value for it.</me:message>
        </me:feedback>        
      </xsl:when>
      
      <xsl:when test="$item != functx:trim($item)">
        <me:feedback type="warning" class="{$class}" id="{$idclass}.1">
          <me:src ref="iati" versions="any"/>
          <me:message>The identifier <code>{$itemname}</code> should not start or end with spaces or newlines.</me:message>
        </me:feedback>
      </xsl:when>

      <xsl:when test="some $prefix in $org-id-prefixes[@status='withdrawn'] satisfies starts-with(upper-case($item), $prefix)">
        <me:feedback type="info" class="{$class}" id="{$idclass}.9">
          <me:src ref="iati" versions="2.x" href="http://org-id.guide"/>
          <me:message>The identifier <code>{$itemname}</code> starts with a country-specific prefix that it is marked as 'withdrawn'.</me:message>
        </me:feedback>
      </xsl:when>

      <xsl:when test="(
        not (some $prefix in $org-id-prefixes satisfies starts-with($item, $prefix)) 
        and (some $prefix in $org-id-prefixes satisfies starts-with(upper-case($item), $prefix)))">
        <me:feedback type="danger" class="{$class}" id="{$idclass}.5">
          <me:src ref="iati" versions="2.x" href="http://org-id.guide"/>
          <me:message>The identifier <code>{$itemname}</code> is invalid: the country-specific prefix must be written in uppercase.</me:message>
        </me:feedback>
      </xsl:when>

      <xsl:when test="(some $known-old-id in $known-10x-ids satisfies starts-with($item, $known-old-id))">
<!-- Switch off feedback on deprecated organisation identifiers (DFID case)
	TODO: make this a ruleset specific severity once these are processed in the report
        <me:feedback type="info" class="{$class}" id="1.2.12">
          <me:src ref="iati" versions="2.x"/>
          <me:message><code>{$itemname}</code> uses a 1.04 identifier that has been replaced in 1.05.</me:message>
        </me:feedback>-->
      </xsl:when>
    
      <xsl:when test="matches($item, '^[0-9]{5}$')">
        <me:feedback type="warning" class="{$class}" id="{$idclass}.10">
          <me:src ref="iati" versions="1.x" href="http://iatistandard.org/202/organisation-identifiers/"/>
          <me:message>The identifier <code>{$itemname}</code> is a 5-digit code, but not on the list used up to IATI version 1.04. It may be intended as a CRS channel code.</me:message>
        </me:feedback>
      </xsl:when>
      
      <xsl:when test="not(some $prefix in $org-id-prefixes satisfies starts-with($item, $prefix))">
        <me:feedback type="warning" class="{$class}" id="{$idclass}.8">
          <me:src ref="iati" versions="2.x" href="http://org-id.guide"/>
          <me:message>The identifier <code>{$itemname}</code> does not start with a known country-specific prefix.</me:message>
        </me:feedback>
      </xsl:when>

      <xsl:when test="not(some $known-id in $known-publisher-ids satisfies starts-with($item, $known-id))">
        <me:feedback type="info" class="{$class}" id="{$idclass}.11">
          <me:src ref="iati" versions="2.x"/>
          <me:message>The identifier <code>{$itemname}</code> is not on our current list of known publishers.</me:message>
        </me:feedback>
      </xsl:when>

    </xsl:choose>

  <xsl:next-match/>
</xsl:template>

<!--
    Message ids no longer present: 1.2.4
    Messages renumbered: identifier-specific tests 1.2.x now have their own numbers, 1.3.x, 1.4.x, etc.
  -->
</xsl:stylesheet>
