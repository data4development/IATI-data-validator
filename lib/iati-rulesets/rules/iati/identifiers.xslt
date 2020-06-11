<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="iati-identifier" mode="rules" priority="1.1">

    <xsl:if test="not(some $id in (../reporting-org/@ref, ../other-identifier[@type='B1']/@ref) satisfies starts-with(., $id))">
      <me:feedback type="warning" class="identifiers" id="1.1.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The activity identifier should begin with the organisation identifier of the reporting organisation (or a previous version included as other-identifier).</me:message>
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
  
  <xsl:template match="participating-org|provider-org|receiver-org" mode="rules" priority="1.2">
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

  <xsl:template match="reporting-org" mode="rules" priority="1.7">
    <xsl:choose>
      <xsl:when test="not(@ref)">
        <me:feedback type="danger" class="identifiers" id="1.7.2">
          <me:src ref="iati" versions="any"/>
          <me:message>The organisation identifier is missing.</me:message>
        </me:feedback>      
      </xsl:when>
    </xsl:choose>
    
    <xsl:next-match/>
  </xsl:template>
  
  <!-- Checks on the identifiers of organisations or activities -->
  <xsl:template match="iati-activity/iati-identifier" mode="rules" priority="1.3">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.3</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    

  <xsl:template match="iati-organisation/iati-identifier|organisation-identifier" mode="rules" priority="1.13">
    <xsl:call-template name="org_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.13</xsl:with-param>
      <xsl:with-param name="versions">1.0x</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="organisation-identifier" mode="rules" priority="1.12">
    <xsl:call-template name="org_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">organisation</xsl:with-param>
      <xsl:with-param name="idclass">1.12</xsl:with-param>
      <xsl:with-param name="versions">2.0x</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
    
  <xsl:template match="reporting-org/@ref" mode="rules" priority="1.14">
    <xsl:call-template name="org_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.14</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="participating-org/@ref" mode="rules" priority="1.8">
    <xsl:call-template name="org_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">participating</xsl:with-param>
      <xsl:with-param name="idclass">1.8</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="@activity-id" mode="rules" priority="1.9">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">participating</xsl:with-param>
      <xsl:with-param name="idclass">1.9</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="@provider-activity-id" mode="rules" priority="1.4">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">financial</xsl:with-param>
      <xsl:with-param name="idclass">1.4</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="@receiver-activity-id" mode="rules" priority="1.5">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">financial</xsl:with-param>
      <xsl:with-param name="idclass">1.5</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="provider-org/@ref" mode="rules" priority="1.10">
    <xsl:call-template name="org_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">financial</xsl:with-param>
      <xsl:with-param name="idclass">1.10</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="receiver-org/@ref" mode="rules" priority="1.15">
    <xsl:call-template name="org_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">organisation</xsl:with-param>
      <xsl:with-param name="idclass">1.15</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="other-identifier[upper-case(@type)=('A3')]/@ref" mode="rules" priority="1.6">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.6</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    

  <xsl:template match="other-identifier[upper-case(@type)=('B1')]/@ref" mode="rules" priority="1.16">
    <xsl:call-template name="org_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.16</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="owner-org/@ref" mode="rules" priority="1.11">
    <xsl:call-template name="org_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">participating</xsl:with-param>
      <xsl:with-param name="idclass">1.11</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
    
  <xsl:template match="related-activity/@ref" mode="rules" priority="1.7">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">relations</xsl:with-param>
      <xsl:with-param name="idclass">1.7</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
</xsl:stylesheet>
