<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iana="http://www.iana.org/assignments"
  exclude-result-prefixes="iana"
  expand-text="yes">

  <xsl:output indent="yes"/>

  <xsl:template match="/">
    <codelist>
      <xsl:apply-templates select="//iana:file[@type='template']"/>
    </codelist>
  </xsl:template>

  <xsl:template match="iana:file">
    <code>{.}</code>
  </xsl:template>
</xsl:stylesheet>
