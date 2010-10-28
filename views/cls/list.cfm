<cfquery name="cls" datasource="#request.dsn#">
  SELECT 
    classifications.name AS classification, 
    classification_levels.name AS level
  FROM classifications
  JOIN classification_levels 
  ON classifications.id = classification_levels.classification_id
  ORDER BY classifications.name, classification_levels.name
</cfquery>

<cfoutput>

<h1>Classifications and Levels</h1>

<table>
  <tbody>
    <tr>
      <td>
        <cfset startrow = 1 />
        <cfset endrow = cls.recordcount / 3 />
        <cfloop query="cls" startrow="#startrow#" endrow="#endrow#">
          #cls.classification# / #cls.level#<br />
        </cfloop>
      </td>
      <td>
        <cfset startrow = endrow + 1 />
        <cfset endrow = (cls.recordcount / 3) * 2 />
        <cfloop query="cls" startrow="#startrow#" endrow="#endrow#">
          #cls.classification# / #cls.level#<br />
        </cfloop>
      </td>
      <td>
        <cfset startrow = endrow + 1 />
        <cfset endrow = cls.recordcount />
        <cfloop query="cls" startrow="#startrow#" endrow="#endrow#">
          #cls.classification# / #cls.level#<br />
        </cfloop>
      </td>
    </tr>
  </tbody>
</table>

<form action="index.cfm?event=cls.process" method="post">
  <input id="classification" name="classification" type="text" maxlength="8" style="width: 70px" /> /
  <input id="level" name="level" type="text" maxlength="6" style="width: 50px" />
  <input type="submit" name="submit" value="Add New" />
</form>

</cfoutput>
