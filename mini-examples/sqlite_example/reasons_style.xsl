<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
  <html>
  <body>
    <h2 align="center">Reasons</h2>
    <table border="1" align="center">
      <tr bgcolor="#9acd32">
        <th>ID</th>
        <th>Description</th>
      </tr>
      <xsl:for-each select="REASONS/REASON">
      <tr>
        <td><xsl:value-of select="ID" /></td>
        <td><xsl:value-of select="DESC" /></td>
      </tr>
      </xsl:for-each>
    </table>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>

