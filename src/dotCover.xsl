<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8"/>

  <xsl:template match="/">

    <script type="text/javascript" src="/ccnet/javascript/dotCover.js"></script>
    <style>
    .coverage-percentage 
    {
        position: absolute;
        padding: 2px 0px 0px 2px;
        color: #fff;
        font-weight:bold;
    }

    .coverage-success 
    {
        background-color:#2E8A2E;
    }
    .coverage-failure 
    {
        background-color:#DF4545;
    }

    .coverage-details th 
    {
        text-align: left;
    }

    .coverage-details .name-display-wrapper 
    {
        max-width:400px;
        overflow:hidden;
        white-space:nowrap;
    }

    .coverage-details .name-display-wrapper.assembly 
    { 
        color:#2E8A2E;
    }
    .coverage-details .name-display-wrapper.namespace 
    {
        padding-left:10px;
        color:#000000;
    }
    .coverage-details .name-display-wrapper.type 
    {
        padding-left:20px;
        color:#BF9D00;
    }
    .coverage-details .name-display-wrapper.method 
    {
        padding-left:30px;
        color:#D00DDF;
    }
    .coverage-details .name-display-wrapper.property 
    {
        padding-left:30px;
        color:#280FFF;
    }
    .coverage-details .name-display-wrapper.constructor
    {
        padding-left:30px;
        color:#A30AAF;
    }
    .coverage-details .name-display-wrapper.anon-method
    , .coverage-details .name-display-wrapper.own-coverage 
    {
        padding-left:40px;
        color:#999999;
    }

    .coverage-details .name-display-wrapper .name-display 
    {
        display:inline;
        width:345px;
        overflow:hidden;
        white-space:nowrap;
        float:left;
    }
    .coverage-details .name-display-wrapper .name-display .expand 
    {
        float:left;
        background:transparent url(/ccnet/images/dotcover-expand.png) no-repeat 0px 0px;
        display:inline;
        width:12px;
        height:15px;
        padding:0px 3px 0px 0px;
        cursor:pointer;
    }
    .coverage-details .name-display-wrapper .name-display .collapse 
    {
        float:left;
        background:transparent url(/ccnet/images/dotcover-collapse.png) no-repeat 0px 0px;
        display:inline;
        width:12px;
        height:15px;
        padding:0px 3px 0px 0px;
        cursor:pointer;
    }
    .coverage-details .name-display-wrapper .name-display .spacer
    {
        float:left;
        display:inline;
        width:12px;
        height:15px;
        padding:0px 3px 0px 0px;
    }
    .coverage-details .name-display-wrapper .name-display .name { }
    .coverage-details .name-display-wrapper.own-coverage .name-display .name 
    {
        font-style:italic;
    }

    </style>
    <xsl:variable name="coverage.root" select="cruisecontrol//Root" />
    <xsl:variable name="coverage.success.percent" select="$coverage.root/@CoveragePercent" />
    <xsl:variable name="coverage.failure.percent" select="100 - $coverage.success.percent" />

    <h1>dotCover Coverage Results</h1>
    <div id="summary">
      <h3>Summary</h3>
      <table>
        <colgroup>
          <col width="140" />
          <col width="300" />
        </colgroup>
        <tbody>
          <tr>
            <td>Covered Statements:</td>
            <td>
              <xsl:value-of select="$coverage.root/@CoveredStatements"/>
            </td>
          </tr>
          <tr>
            <td>Total Statements:</td>
            <td>
              <xsl:value-of select="$coverage.root/@TotalStatements"/>
            </td>
          </tr>
          <tr>
            <td>Covered Percent:</td>
            <td>
              <div class="coverage-percentage">
                <xsl:value-of select="$coverage.success.percent"/>%
              </div>
              <table border="0" cellspacing="1" width="300">
                <tr>
                  <xsl:if test="$coverage.success.percent > 0">
                    <td class="coverage-success">
                      <xsl:attribute name="width">
                        <xsl:value-of select="$coverage.success.percent"/>%
                      </xsl:attribute>
                      &#160;
                    </td>
                  </xsl:if>
                  <xsl:if test="$coverage.failure.percent > 0">
                    <td class="coverage-failure">
                      <xsl:attribute name="width">
                        <xsl:value-of select="$coverage.failure.percent"/>%
                      </xsl:attribute>
                      &#160;
                    </td>
                  </xsl:if>
                </tr>
              </table>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div id="details">
      <h3>Coverage Details:</h3>
      <table width="98%" cellpadding="0" cellspacing="0" class="coverage-details">
        <colgroup>
          <col width="400" />
          <col width="65%" />
          <col width="35%" />
        </colgroup>
        <tr>
          <th>Assembly</th>
          <th>Coverage (%)</th>
          <th>Covered/Total Stmts.</th>
        </tr>
        <xsl:apply-templates select="$coverage.root" />
      </table>
    </div>
  </xsl:template>
  
  <xsl:template match="Assembly[@TotalStatements>0] | Namespace[@TotalStatements>0] | Type[@TotalStatements>0] | Type/Method[@TotalStatements>0] | Constructor[@TotalStatements>0] | Property[@TotalStatements>0] | AnonymousMethod[@TotalStatements>0] | OwnCoverage[@TotalStatements>0]"> <!--  -->
    <xsl:variable name="name" select="./@Name" />
    <xsl:variable name="nodeName" select="name()" />
    <xsl:variable name="level" select="count(ancestor::*)" />
    <xsl:variable name="statements.covered" select="./@CoveredStatements" />
    <xsl:variable name="statements.total" select="./@TotalStatements" />
    <xsl:variable name="coverage.percent" select="./@CoveragePercent" />
    <xsl:variable name="failure.percent" select="100 - $coverage.percent" />
    <xsl:variable name="numberOfChildren" select="count(./*)" />
    <tr>
      <!--<xsl:attribute name="xmlNodeName">
        <xsl:value-of select="$nodeName"/>
      </xsl:attribute>-->
      <xsl:attribute name="xmlNodeLevel">
        <xsl:value-of select="$level"/>
      </xsl:attribute>
      <xsl:if test="$nodeName != 'Assembly'">
        <xsl:attribute name="style">display:none;</xsl:attribute>
      </xsl:if>
      <td>
        <xsl:choose>
          <xsl:when test="$nodeName = 'Assembly'">
            <xsl:attribute name="class">name-display-wrapper assembly</xsl:attribute>
          </xsl:when>
          <xsl:when test="$nodeName = 'Namespace'">
            <xsl:attribute name="class">name-display-wrapper namespace</xsl:attribute>
          </xsl:when>
          <xsl:when test="$nodeName = 'Type'">
            <xsl:attribute name="class">name-display-wrapper type</xsl:attribute>
          </xsl:when>
          <xsl:when test="$nodeName = 'Method'">
            <xsl:attribute name="class">name-display-wrapper method</xsl:attribute>
          </xsl:when>
          <xsl:when test="$nodeName = 'Constructor'">
            <xsl:attribute name="class">name-display-wrapper constructor</xsl:attribute>
          </xsl:when>
          <xsl:when test="$nodeName = 'Property'">
            <xsl:attribute name="class">name-display-wrapper property</xsl:attribute>
          </xsl:when>
          <xsl:when test="$nodeName = 'AnonymousMethod'">
            <xsl:attribute name="class">name-display-wrapper anon-method</xsl:attribute>
          </xsl:when>
          <xsl:when test="$nodeName = 'OwnCoverage'">
            <xsl:attribute name="class">name-display-wrapper own-coverage</xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <xsl:attribute name="title">
          <xsl:value-of select="$name"/>
        </xsl:attribute>
        <div class="name-display">
          <xsl:choose>
            <xsl:when test="$numberOfChildren > 0 and $nodeName != 'Property'">
              <div class="expand" onclick="toggleNodes(this);">
                &#160;
              </div>
            </xsl:when>
            <xsl:otherwise>
              <div class="spacer">&#160;</div>
            </xsl:otherwise>
          </xsl:choose>
          <div class="name">
            <xsl:choose>
              <xsl:when test="$nodeName = 'OwnCoverage'">
                own coverage
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$name"/>
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <div style="clear:both" />
        </div>
      </td>
      <td>
        <div class="coverage-percentage">
          <xsl:value-of select="$coverage.percent"/>%
        </div>
        <table border="0" cellspacing="1" width="95%">
          <tr>
            <xsl:if test="$coverage.percent > 0">
              <td class="coverage-success">
                <xsl:attribute name="width">
                  <xsl:value-of select="$coverage.percent"/>%
                </xsl:attribute>
                &#160;
              </td>
            </xsl:if>
            <xsl:if test="$failure.percent > 0">
              <td class="coverage-failure">
                <xsl:attribute name="width">
                  <xsl:value-of select="$failure.percent"/>%
                </xsl:attribute>
                &#160;
              </td>
            </xsl:if>
          </tr>
        </table>
      </td>
      <td>
        <xsl:value-of select="$statements.covered"/> / <xsl:value-of select="$statements.total"/>
      </td>
    </tr>
    <xsl:apply-templates select="./*" />
  </xsl:template>
  
</xsl:stylesheet>

