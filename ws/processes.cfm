<cfquery name="query" datasource="#request.dsn#">
  SELECT id, number FROM processes
  ORDER BY number DESC
</cfquery>

<cfoutput>
[
  <cfloop query="query">
    {
      "id": "#query.id#",
      "number": "#query.number#"
    }
    <cfif query.currentrow neq query.recordcount>,</cfif>
  </cfloop>
]
</cfoutput>
