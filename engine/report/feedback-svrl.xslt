<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  exclude-result-prefixes="xs me"
  version="3.0"
  expand-text="yes">
  
  <xsl:template match="/">
    <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:apply-templates select="//me:feedback"/>
    </svrl:schematron-output>      
  </xsl:template>

  <xsl:template match="me:feedback">
    <svrl:failed-assert test="false()" location="{path(..)}">
      <xsl:attribute name="role">
        <xsl:choose>
          <xsl:when test="@type='danger'">error</xsl:when>
          <xsl:when test="@type='warning'">warning</xsl:when>
          <xsl:when test="@type='info'">info</xsl:when>
          <xsl:when test="@type='success'">info</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <svrl:property-reference property="class">{@class}</svrl:property-reference>
      <text fpi="{@id}"><xsl:copy-of select="me:message/@*"/><xsl:copy-of select="me:message/(*|text())"/></text>
    </svrl:failed-assert>
  </xsl:template>
</xsl:stylesheet>