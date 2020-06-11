<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  xmlns:saxon="http://saxon.sf.net/"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:param name="filename"/>
  
  <xsl:variable name="schemaVersion">0.10.0</xsl:variable>
  
  <!-- support functions and templates -->
  <xsl:include href="../../lib/functx.xslt"/>
  <xsl:include href="lib/identifiers.xslt"/>
  <xsl:include href="lib/percentages.xslt"/>
  
  <!-- IATI rules -->
  <xsl:include href="iati/technical.xslt"/>
  <xsl:include href="iati/codelists.xslt"/>
  <xsl:include href="iati/sectors.xslt"/>
  <xsl:include href="iati/identifiers.xslt"/>
  <xsl:include href="iati/extra-documentation/geography.xslt"/>
  <xsl:include href="iati/language.xslt"/>
  <xsl:include href="iati/traceability.xslt"/>
  <xsl:include href="iati/information.xslt"/>
  <xsl:include href="iati/financial.xslt"/>
  <xsl:include href="iati/results.xslt"/>
  
  <!-- General practice and donor rules -->
  <xsl:include href="praxis.xslt"/>
  <xsl:include href="donors.xslt"/>

  <xsl:output indent="yes"/>
  
  <xsl:function name="me:iati-url">
    <xsl:param name="href"/>
    <!-- TODO: include iati-version in function call to use proper version -->
    <xsl:variable name="iati-version">2.03</xsl:variable>
    <xsl:if test="$href!=''">http://reference.iatistandard.org/{replace($iati-version, '\.', '')}/{$href}</xsl:if>
  </xsl:function>

  <xsl:function name="me:iati-version">
    <xsl:param name="declared-version"/>

    <xsl:choose>
      <xsl:when test="$declared-version=('1.01','1.02','1.03','1.04','1.05','2.01','2.02','2.03')">{$declared-version}</xsl:when>
      <xsl:when test="starts-with($declared-version, '1.')">1.05</xsl:when>
      <xsl:otherwise>2.03</xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
<!--  <xsl:variable name="validation-errors" select="saxon:validate(/)"/>-->
  
  <xsl:template match="@*|node()">
    <xsl:param name="iati-version" tunnel="yes"/>
    <xsl:param name="iati-activities" tunnel="yes"/>
    <xsl:copy>
      <xsl:variable name="use-iati-version">
        <xsl:choose>
          <xsl:when test="name(.)=('iati-activities', 'iati-organisations')">{me:iati-version(@version)}</xsl:when>
          <xsl:when test="$iati-version">{$iati-version}</xsl:when>
          <xsl:otherwise>2.03</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="use-iati-activities">
        <xsl:choose>
          <xsl:when test="name(.)=('iati-activities')">{.//iati-identifier}</xsl:when>
          <xsl:otherwise>{$iati-activities}</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="name(.)=('iati-activities', 'iati-organisations')">
        <xsl:attribute name="me:id">{iati-identifier}</xsl:attribute>  
        <xsl:attribute name="me:schemaVersion">{$schemaVersion}</xsl:attribute>  
        <xsl:attribute name="me:iatiVersion">{$use-iati-version}</xsl:attribute>  
      </xsl:if>
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="iati-version" select="$use-iati-version" tunnel="yes"/>
        <xsl:with-param name="iati-activities" select="$use-iati-activities" tunnel="yes"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="@*" mode="rules">
        <xsl:with-param name="iati-version" select="$use-iati-version" tunnel="yes"/>
        <xsl:with-param name="iati-activities" select="$use-iati-activities" tunnel="yes"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="rules">
        <xsl:with-param name="iati-version" select="$use-iati-version" tunnel="yes"/>
        <xsl:with-param name="iati-activities" select="$use-iati-activities" tunnel="yes"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="text()" mode="rules">
        <xsl:with-param name="iati-version" select="$use-iati-version" tunnel="yes"/>
        <xsl:with-param name="iati-activities" select="$use-iati-activities" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="rules"/>

  <xsl:template match="codelist" mode="get-codelists">
    <xsl:copy>
      <xsl:copy select="@name"/>
      <xsl:apply-templates select="//code" mode="get-codelists"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="code" mode="get-codelists">
    <xsl:copy>{.}</xsl:copy>
  </xsl:template>  

  <xsl:variable name="iati-codelists">
    <codes version="2.03">
      <xsl:apply-templates select="collection('../lib/schemata/2.03/codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
      <xsl:apply-templates select="collection('../lib/schemata/non-embedded-codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
    </codes>
    <codes version="2.02">
      <xsl:apply-templates select="collection('../lib/schemata/2.02/codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
      <xsl:apply-templates select="collection('../lib/schemata/non-embedded-codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
    </codes>
    <codes version="2.01">
      <xsl:apply-templates select="collection('../lib/schemata/2.01/codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
      <xsl:apply-templates select="collection('../lib/schemata/non-embedded-codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
    </codes>
    <codes version="1.05">
      <xsl:apply-templates select="collection('../lib/schemata/1.05/codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
    </codes>
    <codes version="1.04">
      <xsl:apply-templates select="collection('../lib/schemata/1.04/codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
    </codes>
    <codes version="1.03">
      <xsl:apply-templates select="collection('../lib/schemata/1.03/codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
    </codes>
  </xsl:variable>

  <xsl:function name="me:codeListFail" as="xs:boolean">
    <xsl:param name="code"/>
    <xsl:param name="codelist"/>
    <xsl:param name="iati-version"/>
    
    <xsl:sequence select="$code and 
      $iati-codelists/codes[@version=$iati-version]/codelist[@name=$codelist] and 
      not(($code, lower-case($code), upper-case($code))=$iati-codelists/codes[@version=$iati-version]/codelist[@name=$codelist]/code)"/>
  </xsl:function>

</xsl:stylesheet>
