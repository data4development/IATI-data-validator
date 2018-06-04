<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  expand-text="yes">
  
  <xsl:variable name="mime-types" select="collection('../../lib/?select=mime-types*.xml')//code"/>
  
  <xsl:template match="document-link" mode="rules" priority="6.1">
    <xsl:if test="@format=('application/javascript')">
      <me:feedback type="info" class="documents" id="6.1.1">
        <me:src ref="practice" versions="any"/>
        <me:message>The document format is invalid.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="not(@format = $mime-types)">
      <me:feedback type="warning" class="documents" id="6.1.2">
        <me:src ref="iati" versions="any" href="http://www.iana.org/assignments/media-types/media-types.xhtml"/>
        <me:message>The document format is unknown.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="not(language/@code) or language/@code=''">
      <me:feedback type="info" class="documents" id="6.1.4">
        <me:src ref="iati" versions="any"/>
        <me:message>The document has no language indication.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-activity" mode="rules" priority="6.2">
    <xsl:if test="not(activity-status)">
      <me:feedback type="danger" class="information" id="6.2.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The activity status is missing.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="not(sector) and not(transaction/sector)">
      <me:feedback type="warning" class="classifications" id="6.2.2">
        <me:src ref="iati" versions="any"/>
        <me:message>The activity should have a sector classification for either the activity or the transactions.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="not(policy-marker)">
      <me:feedback type="warning" class="classifications" id="6.2.3">
        <me:src ref="iati" versions="any"/>
        <me:message>The policy marker(s) are missing.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="not(default-flow-type)">
      <me:feedback type="warning" class="classifications" id="6.2.4">
        <me:src ref="iati" versions="any"/>
        <me:message>The default flow type is missing.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="not(default-finance-type)">
      <me:feedback type="info" class="classifications" id="6.2.5">
        <me:src ref="iati" versions="any"/>
        <me:message>The default finance type is missing.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="not(default-aid-type)">
      <me:feedback type="warning" class="classifications" id="6.2.6">
        <me:src ref="iati" versions="any"/>
        <me:message>The default aid type is missing.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="not(default-tied-status)">
      <me:feedback type="warning" class="classifications" id="6.2.7">
        <me:src ref="iati" versions="any"/>
        <me:message>The default tied status is missing.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="reporting-org|participating-org|provider-org|receiver-org" mode="rules" priority="6.3">
    <xsl:if test="not(@type) or @type=''">
      <me:feedback type="warning" class="information" id="6.3.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The organisation type is missing.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
    
</xsl:stylesheet>
