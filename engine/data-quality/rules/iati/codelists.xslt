<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<xsl:template match="iati-activities" mode="rules" priority="9.1">
  <xsl:if test="not($iati-version-valid)">
    <iati-me:feedback type="danger" class="information" id="9.1.1">
      <iati-me:src ref="iati-doc" versions="any"/>
      <iati-me:message>The IATI version number is not valid. Version 2.02 is
        used where a version is needed.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="activity-status" mode="rules" priority="9.2">
  <xsl:if test="not(@code=iati-me:codes('ActivityStatus'))">
    <iati-me:feedback type="danger" class="information" id="9.2.1">
      <iati-me:src ref="iati-doc" versions="any"/>
      <iati-me:message>The activity status is not valid. <xsl:value-of select="iati-me:codes('ActivityStatus')" separator=", "/></iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="recipient-country" mode="rules" priority="9.3">
  <!-- <xsl:if test="not(@code=iati-me:codes('Country'))">
    <iati-me:feedback type="danger" class="information" id="9.3.1">
      <iati-me:src ref="iati-doc" versions="any"/>
      <iati-me:message>The country code is not on the list of valid countries.</iati-me:message>
    </iati-me:feedback>
  </xsl:if> -->

  <xsl:next-match/>
</xsl:template>

<xsl:template match="recipient-region" mode="rules" priority="9.4">
  <!-- <xsl:if test="not(@code=iati-me:codes('Region'))">
    <iati-me:feedback type="danger" class="information" id="9.4.1">
      <iati-me:src ref="iati-doc" versions="any"/>
      <iati-me:message>The region code is not on the list of valid regions.</iati-me:message>
    </iati-me:feedback>
  </xsl:if> -->

  <xsl:next-match/>
</xsl:template>

<xsl:template match="sector" mode="rules" priority="9.5">
  <!-- <xsl:if test="(@vocabulary='1' or not(@vocabulary)) and
    not(@code=iati-me:codes('Sector'))">
    <iati-me:feedback type="danger" class="information" id="9.5.1">
      <iati-me:src ref="iati-doc" versions="any"/>
      <iati-me:message>The DAC sector code is not on the list of valid sectors.</iati-me:message>
    </iati-me:feedback>
  </xsl:if> -->

  <xsl:next-match/>
</xsl:template>

<xsl:function name="iati-me:codes" as="xs:string*">
  <xsl:param name="codelist"/>
  <xsl:try select="doc('/home/lib/schemata/' || $iati-version || '/codelist/' || $codelist || '.xml')//code">
    <xsl:catch select="''"/>
  </xsl:try>
</xsl:function>
</xsl:stylesheet>
