<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="iati-activity[not(recipient-country) and not(recipient-region)]" mode="rules" priority="3.1">
    <xsl:if test="count(recipient-country) = 0">
      <me:feedback type="danger" class="geo" id="3.1.3">
        <me:src ref="iati" versions="any"/>
        <me:message>No recipient countries or regions specified.</me:message>
      </me:feedback>
    </xsl:if>
        
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="iati-activity[(recipient-country or recipient-region) and starts-with($iati-version, '1.')]" mode="rules" priority="2.2">
    <!--* When declaring multiple ``recipient-country`` or ``recipient-region`` then a ``@percentage`` must be declared.  These must sum to 100%.-->
    
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="recipient-country"/>
        <xsl:with-param name="class">geo</xsl:with-param>
        <xsl:with-param name="idclass">3.1</xsl:with-param>
        <xsl:with-param name="item">recipient country</xsl:with-param>
        <xsl:with-param name="items">recipient countries</xsl:with-param>
    </xsl:call-template>
    
    <!-- Check for percentages for multiple recipient regions for the default vocabulary. -->    
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="recipient-region[not(@vocabulary) or @vocabulary=('', '1')]"/>
      <xsl:with-param name="class">geo</xsl:with-param>
      <xsl:with-param name="idclass">3.2</xsl:with-param>
      <xsl:with-param name="item">recipient country</xsl:with-param>
      <xsl:with-param name="items">recipient countries</xsl:with-param>
      <xsl:with-param name="vocabulary" select="'1'"/>
      <xsl:with-param name="iativersion">1.x</xsl:with-param>
    </xsl:call-template>
    
    <!-- Check for multiple recipient region codes per vocabulary. -->
    <xsl:for-each-group select="recipient-region" group-by="@vocabulary">
      <xsl:if test="not(current-grouping-key()=('', '1'))">
        <xsl:call-template name="percentage-checks">
          <xsl:with-param name="group" select="current-group()"/>
          <xsl:with-param name="class">geo</xsl:with-param>
          <xsl:with-param name="idclass">3.4</xsl:with-param>
          <xsl:with-param name="item">recipient region</xsl:with-param>
          <xsl:with-param name="items">recipient regions</xsl:with-param>
          <xsl:with-param name="vocabulary" select="current-grouping-key()"/>
          <xsl:with-param name="iativersion">1.x</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each-group>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-activity[recipient-country and not(recipient-region) and starts-with($iati-version, '2.')]" mode="rules" priority="2.4">
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="recipient-country"/>
      <xsl:with-param name="class" select="'geo'"/>
      <xsl:with-param name="idclass" select="'3.1'"/>
      <xsl:with-param name="item" select="'recipient country'"/>
      <xsl:with-param name="items" select="'recipient countries'"/>
      <xsl:with-param name="iativersion" select="'2.x'"/>
    </xsl:call-template>
    
    <xsl:next-match/>
  </xsl:template>
  
  <!--* It is feasible to have both a ``recipient-country`` and ``recipient-region`` in the same ``iati-activity``.  In such cases, the ``@percentage`` must be declared, and sum to 100 across both elements.-->
  <xsl:template match="iati-activity[recipient-region and starts-with($iati-version, '2.')]" mode="rules" priority="2.5">    
    <!-- Check for percentages for multiple recipient regions for the default vocabulary. -->    
    <xsl:call-template name="geography-percentage-checks">
      <xsl:with-param name="group" select="recipient-country|recipient-region[not(@vocabulary) or @vocabulary=('', '1')]"/>
    </xsl:call-template>
    
    <!-- Check for multiple sector codes per vocabulary. -->
    <xsl:for-each-group select="recipient-country|recipient-region" group-by="@vocabulary">
      <xsl:if test="not(current-grouping-key()=('', '1'))">
        <xsl:call-template name="geography-percentage-checks">
          <xsl:with-param name="group" select="current-group()"/>
          <xsl:with-param name="vocabulary" select="current-grouping-key()"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each-group>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template name="geography-percentage-checks">
    <xsl:param name="group"/>
    <xsl:param name="vocabulary" select="'1'"/>
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="$group"/>
      <xsl:with-param name="class">geo</xsl:with-param>
      <xsl:with-param name="idclass">3.4</xsl:with-param>
      <xsl:with-param name="item">recipient country or region</xsl:with-param>
      <xsl:with-param name="items">recipient countries or regions</xsl:with-param>
      <xsl:with-param name="vocabulary">{$vocabulary}</xsl:with-param>
      <xsl:with-param name="iativersion">2.x</xsl:with-param>
      <xsl:with-param name="href">activity-standard/overview/geography/</xsl:with-param>
    </xsl:call-template>    
  </xsl:template>
  
  <xsl:template match="location" mode="rules" priority="3.2">
    <xsl:if test="not(name)">
      <me:feedback type="info" class="geo" id="3.2.1">
        <me:src ref="practice"/>
        <me:message>The location has no name.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="point[pos]" mode="rules" priority="3.3">
    <xsl:analyze-string select="functx:trim(pos)" regex="^([+-]?\d+(\.\d+)?)\s+([+-]?\d+(\.\d+)?)$">
      <xsl:matching-substring>
        <xsl:if test="abs(number(regex-group(1)))>90">
          <me:feedback type="danger" class="geo" id="3.3.2">
            <me:src ref="iati"/>
            <me:message>The latitude should be in the range -90 to 90.</me:message>
          </me:feedback>        
        </xsl:if>        

        <xsl:if test="abs(number(regex-group(3)))>180">
          <me:feedback type="danger" class="geo" id="3.3.3">
            <me:src ref="iati"/>
            <me:message>The longitude should be in the range -180 to 180.</me:message>
          </me:feedback>        
        </xsl:if>                
      </xsl:matching-substring>
      
      <xsl:non-matching-substring>
        <me:feedback type="danger" class="geo" id="3.3.1">
          <me:src ref="iati"/>
          <me:message>The point position does not consist of two valid real numbers.</me:message>
        </me:feedback>        
      </xsl:non-matching-substring>
    </xsl:analyze-string>
        
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>
