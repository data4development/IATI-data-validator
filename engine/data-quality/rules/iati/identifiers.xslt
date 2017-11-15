<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<xsl:variable name="org-id-prefixes" select="doc('../../lib/org-id.xml')//code"/>
<xsl:variable name="known-publisher-ids" select="doc('/home/data-quality/lib/known-publishers.xml')//code"/>

<xsl:template match="iati-identifier" mode="rules" priority="1.1">

  <xsl:if test="not(starts-with(., ../reporting-org/@ref))">
    <me:feedback type="warning" class="identifiers" id="1.1.1">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>The activity identifier usually begins with the organisation identifier of the reporting organisation.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:if test="//iati-activity[iati-identifier=current()][2]">
    <me:feedback type="danger" class="identifiers" id="1.1.2">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>There are multiple copies of an activity with this identifier.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:if test=". = ../reporting-org/@ref">
    <me:feedback type="danger" class="identifiers" id="1.1.3">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>The activity identifier cannot be the same as the organisation identifier of the reporting organisation.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="reporting-org|participating-org|provider-org|receiver-org" mode="rules" priority="1.2">
  <xsl:choose>
    <xsl:when test="not(@ref) and (@activity-id or @receiver-activity-id or @provider-activity-id)">
      <me:feedback type="info" class="identifiers" id="1.2.3">
        <me:src ref="practice" versions="any"/>
        <me:message>An activity identifier is given, but the identifier for the organisation is missing.</me:message>
      </me:feedback>
    </xsl:when>

    <xsl:when test="not(@ref)">
      <me:feedback type="info" class="identifiers" id="1.2.2">
        <me:src ref="iati-doc" versions="any"/>
        <me:message>No organisation identifier is given.</me:message>
      </me:feedback>      
    </xsl:when>
  </xsl:choose>

  <xsl:if test="matches(@ref, '^[0-9]{5}$')">
    <me:feedback type="info" class="identifiers" id="1.2.10">
      <me:src ref="iati-doc" versions="1.x" href="http://iatistandard.org/202/organisation-identifiers/"/>
      <me:message>The identifier is a 5-digit code. If this represents a version 1.x identifier to an international organisation, replace it with the new identifier.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

  <xsl:template match="iati-identifier|@provider-activity-id|@receiver-activity-id|@ref[not(name(..)=('location', 'transaction'))]" mode="rules" priority="1.21">
    <xsl:variable name="item">
      <xsl:choose>
        <xsl:when test="name(.)=('ref')">{name(..)}/{name()}</xsl:when>
        <xsl:otherwise>{name()}</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

  <xsl:choose>
      <xsl:when test="functx:trim(.)=''">
        <me:feedback type="warning" class="identifiers" id="1.2.7">
          <me:src ref="practice" versions="any"/>
          <me:message><code>{$item}</code> should not be empty but omitted if you don't have a value for it.</me:message>
        </me:feedback>        
      </xsl:when>
      
      <xsl:when test=". != functx:trim(.)">
        <me:feedback type="warning" class="identifiers" id="1.2.1">
          <me:src ref="practice" versions="any"/>
          <me:message><code>{$item}</code> should not start or end with spaces or newlines.</me:message>
        </me:feedback>
      </xsl:when>

      <xsl:when test="some $prefix in $org-id-prefixes[@status='withdrawn'] satisfies starts-with(upper-case(.), $prefix)">
        <me:feedback type="info" class="identifiers" id="1.2.9">
          <me:src ref="iati-doc" versions="2.x" href="http://org-id.guide"/>
          <me:message><code>{$item}</code> starts with a known identifier prefix but it is marked as 'withdrawn'.</me:message>
        </me:feedback>
      </xsl:when>

      <xsl:when test="(
        not (some $prefix in $org-id-prefixes satisfies starts-with(., $prefix)) 
        and (some $prefix in $org-id-prefixes satisfies starts-with(upper-case(.), $prefix)))">
        <me:feedback type="warning" class="identifiers" id="1.2.5">
          <me:src ref="iati-doc" versions="2.x" href="http://org-id.guide"/>
          <me:message>The prefix of <code>{$item}</code> should be in uppercase.</me:message>
        </me:feedback>
      </xsl:when>

      <xsl:when test="not(some $prefix in $org-id-prefixes satisfies starts-with(., $prefix))">
        <me:feedback type="warning" class="identifiers" id="1.2.8">
          <me:src ref="iati-doc" versions="2.x" href="http://org-id.guide"/>
          <me:message><code>{$item}</code> does not start with a known prefix.</me:message>
        </me:feedback>
      </xsl:when>

      <xsl:when test="not(some $known-id in $known-publisher-ids satisfies starts-with(., $known-id))">
        <me:feedback type="info" class="identifiers" id="1.2.11">
          <me:src ref="iati-doc" versions="2.x"/>
          <me:message><code>{$item}</code> is not on our list of known publishers.</me:message>
        </me:feedback>
      </xsl:when>

    </xsl:choose>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
