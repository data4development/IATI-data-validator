<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  exclude-result-prefixes="xs"
  version="3.0"
  expand-text="yes">
  
  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:variable name="errors"><xsl:apply-templates/></xsl:variable>
    <xsl:if test="$errors!=''">
      <xsl:message>
{substring-after(document-uri(/),'/workspace/dest/')}
{$errors}
      </xsl:message>
    </xsl:if>
  </xsl:template>

  <xsl:template match="me:feedback[@class=/*/@me:testclass 
    and not(@id = ancestor::*/me:expect) 
    and not(@id = ancestor::*/me:ignore)]">
    {@class}: unexpected feedback {@id} in {path(..)}.</xsl:template>

  <xsl:template match="me:expect[not(. = ../descendant-or-self::*/me:feedback/@id)]">
    {/*/@me:testclass}: missing feedback {.} in {path(..)}.</xsl:template>
  
  <xsl:template match="*"><xsl:apply-templates select="*"/></xsl:template>
</xsl:stylesheet>
