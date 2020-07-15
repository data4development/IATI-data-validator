<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:template match="transaction[provider-org and receiver-org]" mode="rules" priority="7.1">
  
    <xsl:if test="provider-org/@provider-activity-id eq receiver-org/@receiver-activity-id">
      <me:feedback type="danger" class="financial" id="7.1.1">
        <me:src ref="practice" versions="any"/>
        <me:message>The <code>provider-activity-id</code> and <code>receiver-activity-id</code> are the same: financial flows should be between different activities.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="upper-case(transaction-type/@code)=('2','C')
      and provider-org/@provider-activity-id
      and provider-org/@provider-activity-id != ../iati-identifier
      and not(receiver-org/@receiver-activity-id)">
      <me:feedback type="warning" class="financial" id="7.1.2">
        <me:src ref="practice" versions="any"/>
        <me:message>The transaction is a outgoing commitment from the activity, but has no <code>receiver-activity-id</code>. It might be that the <code>receiver-activity-id</code> is in the wrong place.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="upper-case(transaction-type/@code)=('3','D')
      and provider-org/@provider-activity-id
      and provider-org/@provider-activity-id != ../iati-identifier
      and not(receiver-org/@receiver-activity-id)">
      <me:feedback type="warning" class="financial" id="7.1.3">
        <me:src ref="practice" versions="any"/>
        <me:message>The transaction is a disbursement from the activity, but has no <code>receiver-activity-id</code>. It might be that the <code>receiver-activity-id</code> is in the wrong place.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="upper-case(transaction-type/@code)=('4','E')
      and receiver-org/@receiver-activity-id">
      <me:feedback type="warning" class="financial" id="7.1.4">
        <me:src ref="practice" versions="any"/>
        <me:message>The transaction is an expenditure from the activity, but has a <code>receiver-activity-id</code> suggesting it may be a disbursement.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="transaction[upper-case(transaction-type/@code)=('1','11','IF')]" mode="rules" priority="7.3">
    <xsl:choose>
      <xsl:when test="receiver-org[@ref=current()/../reporting-org/@ref 
        and @receiver-activity-id=current()/../iati-identifier]">
        <me:feedback type="success" class="financial" id="7.3.3">
          <me:src ref="practice" versions="any"/>
          <me:message>The incoming transaction does not need receiver information (although the identifiers given match the activity).</me:message>
        </me:feedback>      
      </xsl:when>
      <xsl:when test="receiver-org[@ref=current()/../reporting-org/@ref]">
        <me:feedback type="success" class="financial" id="7.3.5">
          <me:src ref="practice" versions="any"/>
          <me:message>The incoming transaction does not need receiver identifier (although the identifier given matches the reporting organisation).</me:message>
        </me:feedback>      
      </xsl:when>
      <xsl:when test="receiver-org">
        <me:feedback type="warning" class="financial" id="7.3.2">
          <me:src ref="practice" versions="any"/>
          <me:message>The incoming transaction does not need receiver information, and the information given does not match the activity.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
    
    <xsl:choose>
      <xsl:when test="not(provider-org/@ref!='') and not(provider-org/narrative!='')">
        <me:feedback type="warning" class="financial" id="7.3.1">
          <me:src ref="practice" versions="any"/>
          <me:message>The incoming transaction has no provider organisation identifier or name.</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="not(provider-org/@provider-activity-id!='')">
        <me:feedback type="warning" class="financial" id="7.3.4">
          <me:src ref="iati" versions="any"/>
          <me:src ref="minbuza" type="danger" versions="any"/>
          <me:message>The incoming transaction has no provider actvity identifier.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
  
    <xsl:next-match/>
  </xsl:template>
    
  <xsl:template match="transaction[upper-case(transaction-type/@code)=('2','3','D','C')]" mode="rules" priority="7.4">
    <xsl:choose>
      <xsl:when test="provider-org[@ref=current()/../reporting-org/@ref 
        and @provider-activity-id=current()/../iati-identifier]">
        <me:feedback type="success" class="financial" id="7.4.3">
          <me:src ref="practice" versions="any"/>
          <me:message>The outgoing transaction does not need provider information (although the identifiers given match the activity).</me:message>
        </me:feedback>      
      </xsl:when>
      <xsl:when test="provider-org[@ref=current()/../reporting-org/@ref]">
        <me:feedback type="success" class="financial" id="7.4.5">
          <me:src ref="practice" versions="any"/>
          <me:message>The outgoing transaction does not need a provider identifier (although the identifier given matches the reporting organisation).</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="provider-org">
        <me:feedback type="warning" class="financial" id="7.4.2">
          <me:src ref="practice" versions="any"/>
          <me:message>The outgoing transaction does not need provider information, and the information given does not match the activity.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
    
    <xsl:choose>
      <xsl:when test="not(receiver-org/@ref!='') and not(receiver-org/narrative!='')">
        <me:feedback type="warning" class="financial" id="7.4.1">
          <me:src ref="practice" versions="any"/>
          <me:message>The outgoing transaction has no receiver organisation identifier or name.</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="receiver-org/@ref!='' and not(receiver-org/@receiver-activity-id!='')">
        <me:feedback type="info" class="financial" id="7.4.4">
          <me:src ref="practice" versions="any"/>
          <me:message>The outgoing transaction has no receiver activity identifier.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>

    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="transaction-date" mode="rules" priority="7.6">
    <xsl:choose>
      <xsl:when test="@iso-date gt ancestor::iati-activity/@last-updated-datetime">
        <me:feedback type="warning" class="financial" id="7.6.1">
          <me:src ref="iati" versions="any"/>
          <me:message>The transaction date is later than the date of the last update of the activity.</me:message>
        </me:feedback>
      </xsl:when>

      <xsl:when test="@iso-date gt ancestor::iati-activities/@generated-datetime">
        <me:feedback type="warning" class="financial" id="7.6.2">
          <me:src ref="iati" versions="any"/>
          <me:message>The transaction date is later than the date of generation of the activities file.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="budget" mode="rules" priority="7.5">
    <xsl:if test="value castable as xs:decimal and value=(0, '0')">
      <me:feedback type="warning" class="financial" id="7.5.1">
        <me:src ref="practice" versions="any"/>
        <me:message>The budget has a value of 0.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="not(value/@value-date)">
      <me:feedback type="danger" class="financial" id="7.5.2">
        <me:src ref="iati" versions="any"/>
        <me:message>The budget value has no value date.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:if test="xs:date(period-start/@iso-date) + xs:yearMonthDuration('P1Y') lt xs:date(period-end/@iso-date)">
      <me:feedback type="success" class="financial" id="7.5.3">
        <me:src ref="iati" versions="any"/>
        <me:message>The budget period is longer than one year.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="iati-activity" mode="rules" priority="7.7">
    <xsl:if test="not(budget)">
      <me:feedback type="warning" class="financial" id="7.7.2">
        <me:src ref="iati" versions="any"/>
        <me:src ref="minbuza" type="danger" versions="any"/>
        <me:message>No budgets have been defined for this activity.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="value|forecast" mode="rules" priority="7.8">
    <xsl:if test="(not(@currency) or currency='')
      and (not(ancestor::iati-organisation/@default-currency) or ancestor::iati-organisation/@default-currency='')
      and (not(ancestor::iati-activity/@default-currency) or ancestor::iati-activity/@default-currency='')">
      <me:feedback type="danger" class="financial" id="7.8.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The value has no currency and there is no default currency for this activity.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  
</xsl:stylesheet>
