<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="iati-activities" mode="rules" priority="105.1">
    
    <xsl:if test="not(//transaction[transaction-type/@code='11'
      and provider-org/@ref='XM-DAC-7'
      and provider-org/@provider-activity-id])">
      
      <me:feedback type="warning" class="traceability" id="100.1.1">
        <me:src ref="minbuza"/>
        <me:message>Include at least one activity with a transaction of type <code>11</code> (incoming commitment) that refers to the Dutch Ministry of Foreign Affairs (<code>XM-DAC-7</code>) as the provider, and that refers to a specific activity identifier of the Ministry.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
    
  <xsl:template match="iati-activity" mode="rules" priority="101.1">
    
    <xsl:if test="not(result)">
      <me:feedback type="info" class="performance" id="108.1.1">
        <me:src ref="dfid"/>
        <me:src ref="minbuza" type="warning" />
        <me:message>The activity should contain a results section.</me:message>
        <me:description></me:description>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="not(sector[@vocabulary=('1','')] or sector[not(@vocabulary)])">
      <me:feedback type="danger" class="information" id="102.1.1">
        <me:src ref="dfid" versions="any"/>
        <me:src ref="minbuza" versions="any"/>
        <me:message>The activity must have a sector classification using the OECD DAC sector vocabulary.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="recipient-region and 
      not(recipient-region/@vocabulary=('1','') or recipient-region[not(@vocabulary)])">
      <me:feedback type="danger" class="information" id="103.1.1">
        <me:src ref="dfid" versions="any"/>
        <me:src ref="minbuza" versions="any"/>
        <me:message>The region vocabulary code must be either omitted or at least one region vocabulary value must be 1 (OECD/DAC).</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="not(policy-marker/@vocabulary=('1','') or not(policy-marker/@vocabulary))">
      <me:feedback type="danger" class="information" id="106.1.1">
        <me:src ref="minbuza" versions="any"/>
        <me:message>The activity must have a policy-marker using the OECD DAC vocabulary.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="not(//@provider-activity-id
      or //@receiver-activity-id
      or participating-org/@activity-id
      or related-activity/@ref)">
      <me:feedback type="info" class="traceability" id="100.2.1">
        <me:src ref="minbuza"/>
        <me:message>An activity should contain links to other activities, for instance to indicate where funding comes from or goes to, or how it relates to overarching programmes or underlying projects. This helps understand the complete flow, and prevent double counting.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="(
      (participating-org[@ref='XM-DAC-7' and @role='1']) or
      (transaction[provider-org/@ref='XM-DAC-7' and transaction-type/@code='1'])
      ) and not (
      transaction[provider-org/@ref='XM-DAC-7' and transaction-type/@code='11']
      )">
      <me:feedback type="success" class="traceability" id="100.2.2">
        <me:src ref="minbuza"/>
        <me:message>If the Dutch Ministry (<code>XM-DAC-7</code>) is a donor or provider of incoming funds, the activity must have a transaction of type <code>11</code> (incoming commitment)</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>
