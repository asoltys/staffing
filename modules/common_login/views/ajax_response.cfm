<cfset response_structure = event.getArg('response_structure') />
<cfinvoke component="pacific_renewal.includes.json" method="encode" data="#response_structure#" returnvariable="response_json" />
<cfoutput>#response_json#</cfoutput>
