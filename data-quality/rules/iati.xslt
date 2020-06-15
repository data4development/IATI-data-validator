<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  xmlns:saxon="http://saxon.sf.net/"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:include href="iati/technical.xslt"/>
  <xsl:include href="iati/traceability.xslt"/>
  
  <xsl:include href="../../lib/minbuza-rulesets/rules/iati.xslt"/>
  
</xsl:stylesheet>
