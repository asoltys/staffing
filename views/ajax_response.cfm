<cfset response_structure = event.getArg('response_structure') />
<cfinvoke component="hr_staffing.helpers.json" method="encode" data="#response_structure#" returnvariable="response_json" />
<cfheader name="X-JSON" value="#response_json#" />
<cfheader name="Cache-Control" value="no-cache" />
<cfheader name="Pragma" value="no-cache" />
<cfheader name="Expires" value="-1" />