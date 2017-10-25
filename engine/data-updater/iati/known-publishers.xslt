<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:json="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="json"
  expand-text="yes">

  <xsl:output indent="yes"/>

  <xsl:template match="dummy">
    <codelist>
      <xsl:apply-templates select="json-to-xml(unparsed-text('/home/tmp/dstore_iati_codes.json'))//json:map[@key=('publisher_names','publisher_secondary')]/*"/>
    </codelist>
  </xsl:template>

  <xsl:template match="json:string">
    <code>{@key}</code>
  </xsl:template>

</xsl:stylesheet>
