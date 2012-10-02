<?xml version="1.0"?>

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cf="urn:xmlns:org:eurocris:cerif-1.4-0"
>

<xsl:output method="xml" indent="yes"/>

<!-- identity template -->
<xsl:template match="*|text()">
	<xsl:copy>
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>

<xsl:template match="/cf:CERIF/*">
	<xsl:choose>
		<!-- <cfFoo><cfFooId> -->
		<xsl:when test="*[name()=concat(name(parent::*), 'Id')]">
			<xsl:call-template name="expand" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy><xsl:apply-templates /></xsl:copy>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="expand">
	<xsl:copy>
		<xsl:apply-templates select="*[not(contains(name(), '_'))]" />
	</xsl:copy>
	<xsl:call-template name="extract">
		<xsl:with-param name="id" select="*[name()=concat(name(parent::*), 'Id')]" />
		<xsl:with-param name="idname" select="concat(name(), 'Id')" />
	</xsl:call-template>
</xsl:template>

<xsl:template name="extract">
<xsl:param name="id" />
<xsl:param name="idname" />
<xsl:for-each select="*[contains(name(), '_')]">
<xsl:copy>
	<xsl:choose>
		<xsl:when test="*[contains(name(), concat($idname, '1'))]">
			<xsl:element name="{concat($idname, '2')}" namespace="urn:xmlns:org:eurocris:cerif-1.4-0">
				<xsl:value-of select="$id" />
			</xsl:element>
		</xsl:when>
		<xsl:when test="*[contains(name(), concat($idname, '2'))]">
			<xsl:element name="{concat($idname, '1')}" namespace="urn:xmlns:org:eurocris:cerif-1.4-0">
				<xsl:value-of select="$id" />
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="../*[contains(name(), 'Id')]" />
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates />
</xsl:copy>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
