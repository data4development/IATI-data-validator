<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

<xsl:template match="iati-activities" mode="rules" priority="105.1">

  <xsl:if test="not(//transaction[transaction-type/@code='11'
    and provider-org/@ref='XM-DAC-7'
    and provider-org/@provider-activity-id])">

    <iati-me:feedback type="warning" class="traceability" id="100.1.1">
      <iati-me:src ref="minbuza"/>
      <iati-me:message>Include at least one activity with a transaction
      of type <code>11</code> (incoming commitment) that refers to the
      Ministry (<code>XM-DAC-7</code>) as the provider, and that refers to
      a specific activity identifier of the Ministry.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="iati-activity" mode="rules" priority="100.2">

  <xsl:if test="not(//@provider-activity-id
    or //@receiver-activity-id
    or participating-org/@activity-id
    or related-activity/@ref)">
    <iati-me:feedback type="info" class="traceability" id="100.2.1">
      <iati-me:src ref="minbuza"/>
      <iati-me:message>An activity should contain links to other activities,
      for instance to indicate where funding comes from or goes to, or how it
      relates to overarching programmes or underlying projects.
      This helps understand the complete flow, and prevent double
      counting.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="(
    (participating-org[@ref='XM-DAC-7' and @role='1']) or
    (transaction[provider-org/@ref='XM-DAC-7' and transaction-type/@code='1'])
    ) and not (
      transaction[provider-org/@ref='XM-DAC-7' and transaction-type/@code='11']
    )">
    <iati-me:feedback type="warning" class="traceability" id="100.2.2">
      <iati-me:src ref="minbuza"/>
      <iati-me:message>If the Ministry (<code>XM-DAC-7</code>) is a donor or provider of
      incoming funds, the activity must have a transaction of type
      <code>11</code> (incoming commitment)</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
