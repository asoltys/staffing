<cfset position = event.getArg('position') />
<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfoutput>
<h1>Position Created</h1>

<cfif request.server EQ 'Production'>
	<cfset to = "#request.current_user.email#,#position.manager.email#" />
	<cfset bcc = request.human_resources_mailbox />
<cfelse>
	<cfset to = request.admin />
	<cfset bcc = "" />
</cfif>

<cfmail 
	from="PacificWeb.Services@pwgsc-tpsgc.gc.ca"
	to="#to#"
	bcc="#bcc#"
	subject="Newly Created HR Staffing Position" type="html">
	Attention: The following position has been entered into the Human Resources <a href="#request.server_url##request.path#">Staffing Log</a>.
	<br />
	<style>
		table{
			background:##FFFFFF;
			border:1px solid ##CCCCCC;
			border-collapse:collapse;
			font-size:14px;
			margin:20px 10px 10px 10px;
			table-layout:auto;
			width:90%;
		}
		table tr th {
			background:##DDDFE1;
			font-weight:bold;
		}
		table tr td, table tr th {
			border:1px solid ##CCCCCC;
			padding:5px;
		}
		.hideEmail{
			display:none;
		}
	</style>
	<cfinvoke method="position_details" position="#position#">
	This position was added by <a href="mailto:#request.current_user.email#">#request.current_user.first_name# #request.current_user.last_name#</a>. 
</cfmail> 

<p>
	The position has been added to the #position.fiscal_year# staffing log.  An email will be sent to you and the position's manager to notify them of this action.
</p>

<p>	
	If a process is already in place for this position, you may now proceed to <a href="#request.path#index.cfm?event=positions.set_process&amp;position_id=#position.id#">define it here</a>.
</p>

<p>
	Otherwise, <a href="#request.path#index.cfm?event=positions.staffing_log">click here</a> to return to the staffing log.
</p>

</cfoutput>