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
        <me:src ref="iati" versions="any"/>
        <me:message>The IATI version of the dataset is not a valid version number.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="activity-status" mode="rules" priority="9.2">
    <xsl:if test="not(@code=me:codes('ActivityStatus'))">
      <me:feedback type="danger" class="information" id="9.2.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The activity status is invalid.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="recipient-country" mode="rules" priority="9.3">
    <!-- <xsl:if test="not(@code=me:codes('Country'))">
      <me:feedback type="danger" class="information" id="9.3.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The country code is not on the list of valid countries.</me:message>
      </me:feedback>
    </xsl:if> -->
  
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="recipient-region" mode="rules" priority="9.4">
    <!-- <xsl:if test="not(@code=me:codes('Region'))">
      <me:feedback type="danger" class="information" id="9.4.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The region code is not on the list of valid regions.</me:message>
      </me:feedback>
    </xsl:if> -->
  
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="sector" mode="rules" priority="9.5">
    <!-- <xsl:if test="(@vocabulary='1' or not(@vocabulary)) and
      not(@code=me:codes('Sector'))">
      <me:feedback type="danger" class="information" id="9.5.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The DAC sector code is not on the list of valid sectors.</me:message>
      </me:feedback>
    </xsl:if> -->
  
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="default-aid-type" mode="rules" priority="9.6">
    <xsl:if test="not(@code=me:codes('AidType'))">
      <me:feedback type="danger" class="classifications" id="9.6.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The default aid type is invalid.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="default-finance-type" mode="rules" priority="9.7">
    <xsl:if test="not(@code=me:codes('FinanceType'))">
      <me:feedback type="danger" class="classifications" id="9.7.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The default finance type is invalid.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="default-flow-type" mode="rules" priority="9.8">
    <xsl:if test="not(@code=me:codes('FlowType'))">
      <me:feedback type="danger" class="classifications" id="9.8.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The default flow type is invalid.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="default-tied-status" mode="rules" priority="9.9">
    <xsl:if test="not(@code=me:codes('TiedStatus'))">
      <me:feedback type="danger" class="classifications" id="9.9.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The default tied status is invalid.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="policy-marker" mode="rules" priority="9.10">
    <xsl:if test="(not(@vocabulary) or (@vocabulary='1')) and not(@code=me:codes('PolicyMarker'))">
      <me:feedback type="danger" class="classifications" id="9.10.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The policy marker code is invalid.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="not(@vocabulary=me:codes('PolicyMarkerVocabulary'))">
      <me:feedback type="danger" class="classifications" id="9.10.2">
        <me:src ref="iati" versions="any"/>
        <me:message>The policy marker vocabulary is invalid.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="not(@significance=me:codes('PolicySignificance'))">
      <me:feedback type="danger" class="classifications" id="9.10.3">
        <me:src ref="iati" versions="any"/>
        <me:message>The policy marker significance is invalid.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="sector[@vocabulary=('1','')]" mode="rules" priority="9.11">
    <xsl:if test="not(@code=me:codes('Sector'))">
      <me:feedback type="danger" class="classifications" id="9.11.1">
        <me:src ref="iati"/>
        <me:message>The OECD DAC sector is invalid.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
 
  <xsl:template match="@type" mode="rules" priority="9.12">
    <xsl:if test="name(.)=('provider-org', 'receiver-org') and not(.=me:codes('OrganisationType'))">
      <me:feedback type="danger" class="financial" id="9.12.1">
        <me:src ref="iati"/>
        <me:message>The organisation type is invalid.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="name(.)=('reporting-org') and not(.=me:codes('OrganisationType'))">
      <me:feedback type="danger" class="identifiers" id="9.12.2">
        <me:src ref="iati"/>
        <me:message>The organisation type is invalid.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
    
  <xsl:function name="me:codes" as="xs:string*">
    <xsl:param name="codelist"/>
    <xsl:try select="doc('/home/lib/schemata/' || $iati-version || '/codelist/' || $codelist || '.xml')//code">
      <xsl:catch select="''"/>
    </xsl:try>
  </xsl:function>
</xsl:stylesheet>
