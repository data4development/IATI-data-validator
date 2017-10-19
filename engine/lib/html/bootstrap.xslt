<?xml version="1.0" encoding="UTF-8"?>
<!--
  Generic HTML5 page with bootstrap loaded.

  The template provides a generic skeleton, and makes three passes over the
  document root (match="/"):
  - one with mode="html-head" to gather any additional tags for the <head>
  - one with mode="navbar" to add a navigation bar, which in turn uses:
    - mode="navbar-brand" to add a brand element (single div)
    - mode="navbar-links" to add the links (ul list with li links)
  - one with mode="html-body" for the content of the page with the container div

  Import the stylesheet, then override where desired.
-->

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

  <xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>

  <xsl:character-map name="latin1">
    <xsl:output-character character="&#128;" string="&amp;euro;" />
    <xsl:output-character character="&#129;" string="&amp;nbsp;" />
    <xsl:output-character character="&#130;" string="&amp;sbquo;" />
    <xsl:output-character character="&#131;" string="&amp;fnof;" />
    <xsl:output-character character="&#132;" string="&amp;bdquo;" />
    <xsl:output-character character="&#133;" string="&amp;hellip;" />
    <xsl:output-character character="&#134;" string="&amp;dagger;" />
    <xsl:output-character character="&#135;" string="&amp;Dagger;" />
    <xsl:output-character character="&#136;" string="&amp;circ;" />
    <xsl:output-character character="&#137;" string="&amp;permil;" />
    <xsl:output-character character="&#138;" string="&amp;Scaron;" />
    <xsl:output-character character="&#139;" string="&amp;lsaquo;" />
    <xsl:output-character character="&#140;" string="&amp;OElig;" />
    <xsl:output-character character="&#141;" string="&amp;nbsp;" />
    <xsl:output-character character="&#142;" string="&amp;nbsp;" />
    <xsl:output-character character="&#143;" string="&amp;nbsp;" />
    <xsl:output-character character="&#144;" string="&amp;nbsp;" />
    <xsl:output-character character="&#145;" string="&amp;lsquo;" />
    <xsl:output-character character="&#146;" string="&amp;rsquo;" />
    <xsl:output-character character="&#147;" string="&amp;ldquo;" />
    <xsl:output-character character="&#148;" string="&amp;rdquo;" />
    <xsl:output-character character="&#149;" string="&amp;bull;" />
    <xsl:output-character character="&#150;" string="&amp;ndash;" />
    <xsl:output-character character="&#151;" string="&amp;mdash;" />
    <xsl:output-character character="&#152;" string="&amp;tilde;" />
    <xsl:output-character character="&#153;" string="&amp;trade;" />
    <xsl:output-character character="&#154;" string="&amp;scaron;" />
    <xsl:output-character character="&#155;" string="&amp;rsaquo;" />
    <xsl:output-character character="&#156;" string="&amp;oelig;" />
    <xsl:output-character character="&#157;" string="&amp;nbsp;" />
    <xsl:output-character character="&#158;" string="&amp;nbsp;" />
    <xsl:output-character character="&#159;" string="&amp;Yuml;" />
  </xsl:character-map>

  <xsl:template match="/" mode="html-head">
    <title>Bootstrap template</title>
  </xsl:template>

  <xsl:template match="/" mode="html-body">
    <div class="container">
      <div class="page-header">
        <h1>Bootstrap template</h1>
      </div>
      <p>Override with your template match="/" mode="html-body"</p>
    </div>
  </xsl:template>

  <xsl:template match="*" mode="navbar-brand">
    <div class="navbar-brand">DWB</div>
  </xsl:template>

  <xsl:template match="*" mode="navbar-links">
    <ul class="nav navbar-nav">
      <li class="active"><a href="#" class="active">Bootstrap template</a></li>
    </ul>
  </xsl:template>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <!-- Bootstrap and Fuelux addon, own styling -->
        <link rel="stylesheet" href="css/bootstrap.min.css"/>
        <link rel="stylesheet" href="css/fuelux.min.css"/>
        <link rel="stylesheet" href="css/main.css"/>

        <xsl:apply-templates select="." mode="html-head"/>

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
      </head>
      <body class="fuelux">
        <xsl:apply-templates select="." mode="navbar"/>
        <xsl:apply-templates select="." mode="html-body"/>
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/fuelux.min.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="*" mode="navbar">
    <nav class="navbar navbar-default navbar-fixed-top">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse" aria-expanded="false">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <xsl:apply-templates select="." mode="navbar-brand"/>
        </div>
        <div class="navbar-collapse collapse">
          <xsl:apply-templates select="." mode="navbar-links"/>
        </div>
      </div>
    </nav>
  </xsl:template>

</xsl:stylesheet>
