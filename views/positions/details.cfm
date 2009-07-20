<cfheader name="Cache-Control" value="no-cache" />
<cfheader name="Pragma" value="no-cache" />
<cfheader name="Expires" value="-1" />

<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfset position = createObject('component', 'hr_staffing.model.positions.position') />
<cfset position.init(request.dsn) />
<cfset position.read(event.getArg('id')) />
<cfset position.readAssignees() />


<cfoutput>
	<cfif position.hasProcess()><cfinvoke method="process_details" process="#position.process#"></cfif>
	<cfinvoke method="position_details" position="#position#">
	<cfinvoke method="job_details" position="#position#">
</cfoutput>
