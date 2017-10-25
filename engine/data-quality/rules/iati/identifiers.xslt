<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<xsl:variable name="org-id-prefixes" select="doc('../../lib/org-id.xml')//code"/>
<xsl:variable name="known-publisher-ids" select="doc('../../lib/known-publishers.xml')//code"/>

<xsl:template match="iati-activity" mode="rules" priority="1.1">

  <xsl:variable name="id" select="string(iati-identifier)"/>

  <xsl:if test="not(starts-with($id, reporting-org/@ref))">
    <iati-me:feedback type="warning" class="identifiers" id="1.1.1">
      <iati-me:src ref="iati-doc" versions="any"/>
      <iati-me:message>The activity identifier usually begins with the organisation identifier
      of the reporting organisation.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="count(//iati-activity[iati-identifier=$id])>1">
    <iati-me:feedback type="danger" class="identifiers" id="1.1.2">
      <iati-me:src ref="iati-doc" versions="any"/>
      <iati-me:message>There are multiple copies of an activity with this identifier.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="$id = reporting-org/@ref">
    <iati-me:feedback type="danger" class="identifiers" id="1.1.3">
      <iati-me:src ref="iati-doc" versions="any"/>
      <iati-me:message>The activity identifier cannot be the same as the
        organisation identifier of the reporting organisation.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="reporting-org|participating-org|provider-org|receiver-org" mode="rules" priority="1.2">

  <xsl:if test="@ref != functx:trim(@ref)">
    <iati-me:feedback type="warning" class="identifiers" id="1.2.1">
      <iati-me:src ref="practice" versions="any"/>
      <iati-me:message>An organisation identifier should not start or end with spaces or
      newlines.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="not(@ref)">
    <iati-me:feedback type="info" class="identifiers" id="1.2.2">
      <iati-me:src ref="iati-doc" versions="any"/>
      No organisation identifier is given.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="not(@ref) and (activity-id or receiver-activity-id or provider-activity-id)">
    <iati-me:feedback type="info" class="identifiers" id="1.2.3">
      <iati-me:src ref="practice" versions="any"/>
      <iati-me:message>An activity identifier is given, but the identifier for the organisation
      is missing.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="matches(@ref, '^[0-9]{5}$')">
    <iati-me:feedback type="info" class="identifiers" id="1.2.10">
      <iati-me:src ref="iati-doc" versions="1.x" href="http://iatistandard.org/202/organisation-identifiers/"/>
      <iati-me:message>The identifier is a 5-digit code. If this represents a version
        1.x identifier to an international organisation, replace it with the new identifier.
      </iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="(@ref ne upper-case(@ref)) and
      (some $prefix in $org-id-prefixes satisfies starts-with(upper-case(@ref), $prefix))">
      <iati-me:feedback type="warning" class="identifiers" id="1.2.5">
        <iati-me:src ref="iati-doc" versions="2.x" href="http://org-id.guide"/>
        <iati-me:message>The organisation identifier prefix should be in uppercase.</iati-me:message>
      </iati-me:feedback>
    </xsl:when>
    <xsl:when test="not(some $prefix in $org-id-prefixes satisfies starts-with(@ref, $prefix))">
      <iati-me:feedback type="warning" class="identifiers" id="1.2.8">
        <iati-me:src ref="iati-doc" versions="2.x" href="http://org-id.guide"/>
        <iati-me:message>The organisation identifier does not start with a known prefix.</iati-me:message>
      </iati-me:feedback>
    </xsl:when>

    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>

  <xsl:if test="some $prefix in $org-id-prefixes[@status='withdrawn'] satisfies starts-with(upper-case(@ref), $prefix)">
    <iati-me:feedback type="info" class="identifiers" id="1.2.9">
      <iati-me:src ref="iati-doc" versions="2.x" href="http://org-id.guide"/>
      <iati-me:message>The identifier starts with a known identifier prefix but it is marked as 'withdrawn'.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="not(some $known-id in $known-publisher-ids satisfies @ref eq $known-id)">
    <iati-me:feedback type="info" class="identifiers" id="1.2.10">
      <iati-me:src ref="iati-doc" versions="2.x"/>
      <iati-me:message>The identifier is not on our list of known publishers.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="@provider-activity-id=''">
    <iati-me:feedback type="warning" class="identifiers" id="1.2.6">
      <iati-me:src ref="practice" versions="any"/>
      <iati-me:message>The <code>provider-activity-id</code> attribute should not be empty but
      omitted if you don't have the activity identifier.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="@receiver-activity-id=''">
    <iati-me:feedback type="warning" class="identifiers" id="1.2.7">
      <iati-me:src ref="practice" versions="any"/>
      <iati-me:message>The <code>receiver-activity-id</code> attribute should not be empty but
      omitted if you don't have the activity identifier.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
