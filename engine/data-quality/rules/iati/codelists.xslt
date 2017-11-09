<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<xsl:template match="iati-activities|iati-organisations" mode="rules" priority="9.1">
  <xsl:if test="not($iati-version-valid)">
    <me:feedback type="danger" class="iati" id="9.1.1">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>The IATI version number is not valid. Version {$iati-version} is used in the tests when a version is needed.</me:message>
    </me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="activity-status" mode="rules" priority="9.2">
  <xsl:if test="not(@code=me:codes('ActivityStatus'))">
    <me:feedback type="danger" class="iati" id="9.2.1">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>The activity status is not valid. <xsl:value-of select="me:codes('ActivityStatus')" separator=", "/></me:message>
    </me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="recipient-country" mode="rules" priority="9.3">
  <!-- <xsl:if test="not(@code=me:codes('Country'))">
    <me:feedback type="danger" class="information" id="9.3.1">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>The country code is not on the list of valid countries.</me:message>
    </me:feedback>
  </xsl:if> -->

  <xsl:next-match/>
</xsl:template>

<xsl:template match="recipient-region" mode="rules" priority="9.4">
  <!-- <xsl:if test="not(@code=me:codes('Region'))">
    <me:feedback type="danger" class="information" id="9.4.1">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>The region code is not on the list of valid regions.</me:message>
    </me:feedback>
  </xsl:if> -->

  <xsl:next-match/>
</xsl:template>

<xsl:template match="sector" mode="rules" priority="9.5">
  <!-- <xsl:if test="(@vocabulary='1' or not(@vocabulary)) and
    not(@code=me:codes('Sector'))">
    <me:feedback type="danger" class="information" id="9.5.1">
      <me:src ref="iati-doc" versions="any"/>
      <me:message>The DAC sector code is not on the list of valid sectors.</me:message>
    </me:feedback>
  </xsl:if> -->

  <xsl:next-match/>
</xsl:template>

<xsl:function name="me:codes" as="xs:string*">
  <xsl:param name="codelist"/>
  <xsl:try select="doc('/home/lib/schemata/' || $iati-version || '/codelist/' || $codelist || '.xml')//code">
    <xsl:catch select="''"/>
  </xsl:try>
</xsl:function>
</xsl:stylesheet>
