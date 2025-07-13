<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  exclude-result-prefixes="atom"
>
	<xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes" />
	<xsl:template match="/">
		<html
			xmlns="http://www.w3.org/1999/xhtml" lang="en">
			<head>
				<meta charset="utf-8" />
				<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
				<meta http-equiv="content-type" content="text/html; charset=utf-8" />
				<title>
					<xsl:value-of select="atom:feed/atom:title" />
				</title>
				<meta name="color-scheme" content="light dark" />
				<link rel="stylesheet" href="/styles.css" />
			</head>
			<body class="feed">
				<div class="container">
					<section>
						<xsl:apply-templates select="atom:feed" />
					</section>
					<section class="entry-list">
						<xsl:apply-templates select="atom:feed/atom:entry" />
					</section>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="atom:feed">
		<a title="home">
			<xsl:attribute name="href">
				<xsl:value-of select="atom:link[@rel='alternate']/@href" />
			</xsl:attribute>
			<h1>
				<xsl:value-of select="atom:title" />
			</h1>
		</a>
		<xsl:variable name="subtitle" select="atom:feed/atom:subtitle" />
		<xsl:if test="$subtitle">
			<p>
				<xsl:value-of select="$subtitle" />
			</p>
		</xsl:if>
	</xsl:template>

	<xsl:template match="atom:entry">
		<div class="entry">
			<h3>
				<a title="post">
					<xsl:attribute name="href">
						<xsl:value-of select="atom:id" />
					</xsl:attribute>
					<xsl:value-of select="atom:title" disable-output-escaping="yes" />
				</a>
			</h3>
			<p>
				<time>
					<xsl:attribute name="datetime">
						<xsl:value-of select="atom:published" />
					</xsl:attribute>
					Published on
					<xsl:call-template name="format-date">
						<xsl:with-param name="date" select="atom:published"/>
					</xsl:call-template>
				</time>
				<xsl:if test="atom:updated != atom:published">

					<time>
						<xsl:attribute name="datetime">
							<xsl:value-of select="atom:updated" />
						</xsl:attribute>
						 | Updated on
						<xsl:call-template name="format-date">
							<xsl:with-param name="date" select="atom:updated"/>
						</xsl:call-template>
					</time>
				</xsl:if>
			</p>
			<xsl:if test="atom:summary">
				<p>
					<xsl:value-of select="atom:summary"  disable-output-escaping="yes" />
				</p>
			</xsl:if>

		</div>
	</xsl:template>

	<xsl:template name="months">
		<xsl:param name="month"/>
		<xsl:choose>
			<xsl:when test="$month = '01'">Jan</xsl:when>
			<xsl:when test="$month = '02'">Feb</xsl:when>
			<xsl:when test="$month = '03'">Mar</xsl:when>
			<xsl:when test="$month = '04'">Apr</xsl:when>
			<xsl:when test="$month = '05'">May</xsl:when>
			<xsl:when test="$month = '06'">Jun</xsl:when>
			<xsl:when test="$month = '07'">Jul</xsl:when>
			<xsl:when test="$month = '08'">Aug</xsl:when>
			<xsl:when test="$month = '09'">Sep</xsl:when>
			<xsl:when test="$month = '10'">Oct</xsl:when>
			<xsl:when test="$month = '11'">Nov</xsl:when>
			<xsl:when test="$month = '12'">Dec</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="format-date">
		<xsl:param name="date" />

		<xsl:variable name="short" select="substring($date, 1, 16)" />
		<xsl:variable name="year" select="substring($short, 1, 4)" />
		<xsl:variable name="month" select="substring($short, 6, 2)" />
		<xsl:variable name="day" select="substring($short, 9, 2)" />
		<xsl:variable name="hour" select="substring($short, 12, 2)" />
		<xsl:variable name="minute" select="substring($short, 15, 2)" />

		<xsl:variable name="month-abbreviation">
			<xsl:call-template name="months">
				<xsl:with-param name="month" select="$month"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="concat($month-abbreviation, ' ', number($day), ' ', $year)" />
	</xsl:template>
</xsl:stylesheet>
