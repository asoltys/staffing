<cfquery name="query" datasource="#request.dsn#">
SELECT * FROM processes
</cfquery>

<cfinvoke component="hr_staffing.helpers.json" method="encode" data="#query#" returnvariable="json" />

<cfoutput>#json#</cfoutput>
