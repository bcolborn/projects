<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
  xmlns:u="http://www.nutanix.com" exclude-result-prefixes="xs saxon"
  xpath-default-namespace="http://www.w3.org/1999/xhtml" version="2.0">
  <xsl:strip-space elements="*" />
  <xsl:output method="text" encoding="utf-8" indent="no" />
  <xsl:output name="xml" method="xml" indent="yes" />
  <xsl:output name="html" method="html" indent="no" />
  <xsl:param name="id">Unk</xsl:param>
  <xsl:param name="topicPath">topics/</xsl:param>
  <xsl:param name="helpSite" />
  <xsl:param name="basePath">#/page/docs/details?targetId=</xsl:param>
  <xsl:param name="doc" />
  <xsl:variable name="pathDelimiter">/</xsl:variable>
  <xsl:template match="/">
    <xsl:apply-templates select="/" mode="content" />
  </xsl:template>
  <xsl:template match="/" mode="content">
    <xsl:variable name="documentType"
      select="/html/head/meta[@name='DC.Coverage']/@content" />
    <xsl:variable name="title" select="/html/head/title/text()" />
    <xsl:variable name="uniqueKey" select="$id" />

    <xsl:text>{
      </xsl:text>
    <xsl:call-template name="jsonObject">
      <xsl:with-param name="key">title</xsl:with-param>
      <xsl:with-param name="value" select="$title" />
    </xsl:call-template>
    <xsl:call-template name="jsonObject">
      <xsl:with-param name="key">documentType</xsl:with-param>
      <xsl:with-param name="value" select="$documentType" />
    </xsl:call-template>
    <xsl:call-template name="jsonObject">
      <xsl:with-param name="key">id</xsl:with-param>
      <xsl:with-param name="value" select="$id" />
    </xsl:call-template>
    <xsl:call-template name="jsonObject">
      <xsl:with-param name="key">uniqueKey</xsl:with-param>
      <xsl:with-param name="value" select="$uniqueKey" />
    </xsl:call-template>

    <xsl:text>"ancestors": []
      </xsl:text>
    <xsl:apply-templates select="/html/body/div[@class='static-toc']/ul">
      <xsl:with-param name="parentKey" select="$uniqueKey" />
    </xsl:apply-templates>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="ul">
    <xsl:param name="parentKey" />
    <xsl:if test="li[not(contains(@class, 'resource-only'))]">
      <xsl:text>, "documents": [</xsl:text>
      <xsl:apply-templates select="li[not(contains(@class, 'resource-only'))]">
        <xsl:with-param name="parentKey" select="$parentKey" />
      </xsl:apply-templates>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="li[contains(@class, 'ui-help')]" mode="ui_help"
     />
  </xsl:template>

  <xsl:template match="li">
    <xsl:param name="parentKey" />
    <xsl:variable name="topic" select="a/@href" />
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="a">
          <xsl:value-of
            select="normalize-space(document($topic)/html/head/title)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(text()[1])" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="$topic">
          <xsl:value-of select="substring-after($topic, $topicPath)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="replace($title, '\s+', '_')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="uniqueKey"
      select="concat($parentKey, $pathDelimiter, $id)" />
    <xsl:text>{</xsl:text>

    <xsl:call-template name="jsonObject">
      <xsl:with-param name="key">title</xsl:with-param>
      <xsl:with-param name="value" select="$title" />
    </xsl:call-template>

    <xsl:call-template name="jsonObject">
      <xsl:with-param name="key">id</xsl:with-param>
      <xsl:with-param name="value" select="$id" />
    </xsl:call-template>

    <xsl:call-template name="jsonObject">
      <xsl:with-param name="key">uniqueKey</xsl:with-param>
      <xsl:with-param name="value" select="$uniqueKey" />
    </xsl:call-template>


      <xsl:call-template name="jsonObject">
        <xsl:with-param name="key">documentType</xsl:with-param>
        <xsl:with-param name="value"
          select="document($topic)/html/head/meta[@name='DC.Coverage'][1]/@content"
         />
      </xsl:call-template>

    <xsl:text>"ancestors": [</xsl:text>
    <xsl:for-each select="tokenize($uniqueKey, $pathDelimiter)">
      <xsl:variable name="ancestor"
        select="substring-before($uniqueKey, concat($pathDelimiter, .))" />
      <xsl:if test="matches($ancestor, '[\w]+')">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$ancestor" />
        <xsl:text>"</xsl:text>
        <xsl:if test="position() != last()">
          <xsl:text>,
        </xsl:text>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>],
    </xsl:text>

    <xsl:if test="document($topic)/html/head/meta[@name='abstract'][1]/@content">
      <xsl:call-template name="jsonObject">
        <xsl:with-param name="key">summary</xsl:with-param>
        <xsl:with-param name="value"
          select="string(document($topic)/html/head/meta[@name='abstract'][1]/@content)"
         />
      </xsl:call-template>
    </xsl:if>

    <xsl:call-template name="jsonObject">
      <xsl:with-param name="key">body</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:copy-of
          select="document($topic)/html/body/div[contains(@class, 'body')] | document($topic)/html/body/div[contains(@class, 'topic')]" />
        <xsl:copy-of
          select="document($topic)/html/body/div[contains(@class, 'related-links')]"
         />
      </xsl:with-param>
      <xsl:with-param name="isNode">true()</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="jsonObject">
      <xsl:with-param name="key">href</xsl:with-param>
      <xsl:with-param name="value" select="$topic" />
      <xsl:with-param name="isLast">
        <xsl:choose>
          <xsl:when test="ul">
            <xsl:value-of select="false()" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="true()" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates select="ul">
      <xsl:with-param name="parentKey" select="$uniqueKey" />
    </xsl:apply-templates>

    <xsl:text>}
    </xsl:text>
    <xsl:if test="position() != last()">
      <xsl:text>,</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="jsonObject">
    <xsl:param name="isNode" select="false()" />
    <xsl:param name="key" required="yes" />
    <xsl:param name="value" />
    <xsl:param name="isLast" select="false()" />

    <xsl:variable name="objValue">
      <xsl:choose>
        <xsl:when test="$isNode">
          <xsl:copy-of select="saxon:serialize($value, 'html')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($value)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:text>"</xsl:text>
    <xsl:value-of select="$key" />
    <xsl:text>": "</xsl:text>
    <xsl:copy-of select="encode-for-uri($objValue)" />

    <xsl:text>"</xsl:text>
    <xsl:if test="not($isLast)">
      <xsl:text>,
      </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:function name="u:norm">
    <xsl:param name="origString" />
    <xsl:value-of
      select="replace(normalize-space($origString), '\s+', '_')" />
  </xsl:function>
</xsl:stylesheet>
