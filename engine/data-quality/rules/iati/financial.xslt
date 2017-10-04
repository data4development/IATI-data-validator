<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="transaction[provider-org and receiver-org]" mode="rules" priority="7.1">

  <xsl:if test="provider-org/@provider-activity-id eq receiver-org/@receiver-activity-id">
    <iati-me:feedback type="warning" class="financial" id="7.1.1">
      <iati-me:message>The <code>provider-activity-id</code> and
      <code>receiver-activity-id</code> are the same: financial flows should be between
      different activities.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="upper-case(transaction-type/@code)=('2','C')
    and provider-org/@provider-activity-id
    and provider-org/@provider-activity-id != ../iati-identifier
    and not(receiver-org/@receiver-activity-id)">
    <iati-me:feedback type="warning" class="financial" id="7.1.2">
      <iati-me:message>The transaction is a commitment from the activity,
      and has a <code>provider-activity-id</code>
      that is different from the activity identifier
      but no <code>receiver-activity-id</code>.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="upper-case(transaction-type/@code)=('3','D')
    and provider-org/@provider-activity-id
    and provider-org/@provider-activity-id != ../iati-identifier
    and not(receiver-org/@receiver-activity-id)">
    <iati-me:feedback type="warning" class="financial" id="7.1.3">
      <iati-me:message>The transaction is a disbursement from the activity,
      and has a <code>provider-activity-id</code>
      that is different from the activity identifier
      but no <code>receiver-activity-id</code>.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="upper-case(transaction-type/@code)=('4','E')
    and receiver-org/@receiver-activity-id">
    <iati-me:feedback type="warning" class="financial" id="7.1.4">
      <iati-me:message>The transaction is an expenditure from the activity,
      but has a <code>receiver-activity-id</code>
      suggesting it may be a disbursement.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

<xsl:template match="transaction[provider-org/@provider-activity-id and receiver-org/@receiver-activity-id]" mode="rules" priority="7.2">
  <xsl:if test="provider-org/@provider-activity-id = receiver-org/@receiver-activity-id">
    <iati-me:feedback type="warning" class="financial" id="7.2.1">
      <iati-me:message>The provider and receiver activity identifiers in the transaction should
      not be the same.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>
  <xsl:next-match/>
</xsl:template>

<xsl:template match="transaction[transaction-type/@code=('1','11')]" mode="rules" priority="7.3">
  <xsl:if test="not(provider-org/@ref!='') and not(provider-org/narrative!='')">
    <iati-me:feedback type="warning" class="financial" id="7.3.1">
      <iati-me:message>The incoming transaction has no provider organisation identifier or name.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>
  <xsl:next-match/>
</xsl:template>

<xsl:template match="transaction[transaction-type/@code=('2','3')]" mode="rules" priority="7.4">
  <xsl:if test="not(receiver-org/@ref!='') and not(receiver-org/narrative!='')">
    <iati-me:feedback type="warning" class="financial" id="7.4.1">
      <iati-me:message>The outgoing transaction has no receiver organisation identifier or name.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>
  <xsl:next-match/>
</xsl:template>

<xsl:template match="budget" mode="rules">
  <xsl:if test="value=0 or value='0'">
    <iati-me:feedback type="warning" class="financial" id="7.5.1">
      <iati-me:message>The budget has a value of 0.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="not(value/@value-date)">
    <iati-me:feedback type="danger" class="financial" id="7.5.2">
      <iati-me:message>The budget value has no value date.</iati-me:message>
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>
