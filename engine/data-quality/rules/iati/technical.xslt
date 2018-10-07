<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:template match="iati-activities|iati-organisations" mode="rules" priority="10.1">
    <xsl:if test="doc-available('/workspace/tmp/iatifeedback/'||$filename)">
      <xsl:apply-templates select="doc('/workspace/tmp/iatifeedback/'||$filename)/*" mode="technical"/>  
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-file-with-schema-errors" mode="technical">
    <me:feedback type="danger" class="iati" id="0.3.1">
      <me:src ref="iati" versions="any"/>
      <me:message>The file is not a valid IATI file. The raw feedback from schema validation:

{unparsed-text("/workspace/tmp/xmlschemalog/" || $filename)}</me:message>
    </me:feedback>
  </xsl:template>
  
  <xsl:template match="recovered-iati-file-with-schema-errors" mode="technical">
    <me:feedback type="danger" class="iati" id="0.3.1">
      <me:src ref="iati" versions="any"/>
      <me:message>The file is not a valid XML. A recovered version also is not a valid IATI file.
The raw feedback from xmllint:

{unparsed-text("/workspace/tmp/xmltestlog/" || $filename)}
        
The raw feedback from schema validation:
        
{unparsed-text("/workspace/tmp/xmlschemalog/" || $filename)}</me:message>
    </me:feedback>
  </xsl:template>

  <xsl:template match="recovered-iati-file" mode="technical">
    <me:feedback type="danger" class="iati" id="0.3.1">
      <me:src ref="iati" versions="any"/>
      <me:message>The file is not a valid XML. A recovered version does form a valid IATI file, but may not contain all information. The raw feedback from xmllint:
        
{unparsed-text("/workspace/tmp/xmltestlog/" || $filename)}</me:message>
    </me:feedback>
  </xsl:template>
  

</xsl:stylesheet>  