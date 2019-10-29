<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/2005/xpath-functions" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs me"
  version="3.0"
  expand-text="yes">
  
<!--  <xsl:output method="json"/>-->
  <xsl:output  method="text" indent="yes" media-type="text/json" omit-xml-declaration="yes"/>
  
  <xsl:import href="../lib/functx.xslt"/>
  <xsl:import href="../lib/iati.me/feedback-plain.xslt"/><!-- todo: provides templates for context strings, rename -->
  <xsl:variable name="categories" select="$feedback-meta/me:categories/me:category"/>
  <xsl:variable name="severities" select="$feedback-meta/me:severities/me:severity"/>
  
  <xsl:template match="/">
    <xsl:variable name="j">
      <map>
        <string key="schemaVersion">{*/@me:schemaVersion}</string>
        <string key="iatiVersion">{*/@me:iatiVersion}</string>
        <xsl:apply-templates/>
      </map>
    </xsl:variable>
    {xml-to-json($j)}
  </xsl:template>

  <xsl:template match="/*">
    <string key="filetype">
      <xsl:apply-templates select="." mode="filetype"/>
    </string>
    <string key="validation">
      <xsl:apply-templates select="." mode="validation"/>
    </string>
    
    <xsl:variable name="t" as="node()*">
      <xsl:sequence select="me:feedback"/>
      <xsl:if test="not(//me:feedback[@type=('danger', 'critical')])">
        <me:feedback type="success" class="iati" id="0.0.1">
          <me:src ref="iati" versions="any"/>
          <me:message>Congratulations! This IATI activity file has successfully passed validation with no errors!</me:message>
        </me:feedback>
      </xsl:if>
    </xsl:variable>
    <xsl:call-template name="feedback">
      <xsl:with-param name="feedback" select="$t"/>
    </xsl:call-template>

    <xsl:where-populated>
      <array key="activities">
        <xsl:apply-templates select="iati-activity"/>
      </array>          
    </xsl:where-populated>

    <xsl:where-populated>
      <array key="organisations">
        <xsl:apply-templates select="iati-organisation"/>
      </array>          
    </xsl:where-populated>
  </xsl:template>

  <xsl:template match="iati-activities|iati-organisations" mode="filetype">
    <xsl:value-of select="local-name(.)"/>  
  </xsl:template>
  
  <xsl:template match="*" mode="filetype">
    <xsl:text>not-iati</xsl:text>  
  </xsl:template>
  
  <xsl:template match="*" mode="validation">
    
      <xsl:choose>
        <xsl:when test="'0.1.1'=me:feedback/@id">not-an-xml-file</xsl:when>        
        <xsl:when test="'0.2.1'=me:feedback/@id">not-an-iati-file</xsl:when>        
        <xsl:when test="'0.3.1'=me:feedback/@id">iati-with-schema-errors</xsl:when>
        <xsl:when test="'0.4.1'=me:feedback/@id">iati-with-xml-and-schema-errors</xsl:when>
        <xsl:when test="'0.5.1'=me:feedback/@id">iati-with-xml-errors</xsl:when>
        <xsl:otherwise>ok</xsl:otherwise>
      </xsl:choose>
    
  </xsl:template>

  <xsl:template match="iati-activity">
    <map>
      <string key="title">{title[1]/narrative[1]}</string>
      <string key="identifier">{iati-identifier}</string>
      <string key="publisher">{reporting-org/@ref}</string>
      <xsl:call-template name="feedback">
        <xsl:with-param name="feedback" select="descendant::me:feedback"/>
      </xsl:call-template>
    </map>
  </xsl:template>

  <xsl:template match="iati-organisation">
    <map>
      <string key="title">{name[1]/narrative[1]}</string>
      <string key="identifier">{organisation-identifier/text()[1]}</string>
      <string key="publisher">{reporting-org/@ref}</string>
      <xsl:call-template name="feedback">
        <xsl:with-param name="feedback" select="descendant::me:feedback"/>
      </xsl:call-template>
    </map>
  </xsl:template>

  <xsl:template name="feedback">
    <xsl:param name="feedback"/>
    <array key="feedback">
      <xsl:for-each-group select="$feedback" group-by="@class">
        <map>
          <string key="category">{current-grouping-key()}</string>
          <string key="label">{$feedback-meta/me:categories/me:category[@class=current-grouping-key()]/me:title}</string>
          <array key="messages">
            <xsl:for-each-group select="current-group()" group-by="@id">
              <map>
                <string key="id">{current-grouping-key()}</string>
                <string key="text">{current-group()[1]/me:message}</string>
                <array key="rulesets">
                  <xsl:apply-templates select="current-group()[1]/me:src"/>
                </array>
                <array key="context">
                  <xsl:apply-templates select="current-group()"/>
                </array>
              </map>                
            </xsl:for-each-group>              
          </array>
        </map>
      </xsl:for-each-group>
    </array>
  </xsl:template>
  
  <xsl:template match="me:src">
    <map>
      <string key="src">{@ref}</string>
      <string key="severity">{(@type, ../@type)[1]}</string>
      <xsl:apply-templates select="@href"/>
    </map>    
  </xsl:template>
  
  <xsl:template match="@href">
    <string key="href">{.}</string>
  </xsl:template>
  
  <xsl:template match="me:feedback">
    <map>
      <string key="text"><xsl:apply-templates select=".." mode="context"/></string>
    </map>
  </xsl:template>
</xsl:stylesheet>