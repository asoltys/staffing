<cfset branches = event.getArg('branches') />
<cfset classifications = event.getArg('classifications') />
<cfset direction = event.getArg('direction') />
<cfset groups = event.getArg('groups') />
<cfset locations = event.getArg('locations') />
<cfset regions = event.getArg('regions') />
<cfset orderings = event.getArg('orderings') />
<cfset phases = event.getArg('phases') />
<cfset positions = event.getArg('positions') />
<cfset security_levels = event.getArg('security_levels') />
<cfset staffing_methods = event.getArg('staffing_methods') />
<cfset statuses = event.getArg('statuses') />
<cfset tenures = event.getArg('tenures') />

<cfset current_region = event.getArg('region') />

<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfoutput>

<cfif event.getArg('fiscal_year') EQ "" AND event.getArg('archived') NEQ "">
	<cfinclude template="archive.cfm" />
<cfelse>
	<cfinclude template="positions.cfm" />
</cfif>

</cfoutput>
