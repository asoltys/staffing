<cfquery name="processes" datasource="#request.dsn#">
SELECT * FROM processes
</cfquery>

<cfinvoke component="hr_staffing.helpers.json" method="encode" data="#processes#" returnvariable="json" />

<cfoutput>#json#</cfoutput>
