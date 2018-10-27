<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  exclude-result-prefixes="xs"
  version="3.0">

  <xsl:mode name="identity" on-no-match="deep-copy"/>
  
  <xsl:template match="/">
    <xsl:apply-templates mode="identity"/>
  </xsl:template>
</xsl:stylesheet>