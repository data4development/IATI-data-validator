<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/2005/xpath-functions" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  exclude-result-prefixes="xs me"
  version="3.0"
  expand-text="yes">
  
<!--  <xsl:output method="json"/>-->
  <xsl:output  method="text" indent="yes" media-type="text/json" omit-xml-declaration="yes"/>
  
  <xsl:import href="../lib/functx.xslt"/>
  <xsl:import href="../lib/iati.me/feedback-plain.xslt"/>
  <xsl:variable name="categories" select="$feedback-meta/me:categories/me:category"/>
  <xsl:variable name="severities" select="$feedback-meta/me:severities/me:severity"/>
  
  <xsl:template match="/">
    <xsl:variable name="j">
      <map>
        <array key="activities">
          <xsl:apply-templates select="iati-activities/iati-activity"/>
        </array>
      </map>
    </xsl:variable>
   {xml-to-json($j)}
  </xsl:template>

  <xsl:template match="iati-activity">
    <map>
      <string key="title">{title[1]/narrative[1]}</string>
      <string key="identifier">{iati-identifier}</string>
      <string key="publisher">{reporting-org/@ref}</string>
      <array key="feedback">
        <xsl:for-each-group select="descendant::me:feedback" group-by="@class">
          <map>
            <string key="category">{current-grouping-key()}</string>
            <string key="label">{$feedback-meta/me:categories/me:category[@class=current-grouping-key()]/me:title}</string>
            <array key="messages">
              <xsl:for-each-group select="current-group()" group-by="@id">
                <map>
                  <string key="id">{current-grouping-key()}</string>
                  <string key="text">{current-group()[1]/me:message}</string>
                  <array key="rulesets">
                    <map>
                      <string key="src">{current-group()[1]/me:src/@ref}</string>
                      <string key="severity">{current-group()[1]/@type}</string>
                    </map>
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
    </map>
  </xsl:template>

  <xsl:template match="me:feedback">
    <map>
      <string key="text"><xsl:apply-templates select="." mode="context"/></string>
    </map>
  </xsl:template>
</xsl:stylesheet>