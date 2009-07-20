<cfset position = event.getArg('data_object') />
<cfset history = event.getArg('history') />
<cfoutput>
<h1>Staffing Service Delivery Agreement History Log</h1>
<table>
	<caption>Position Details</caption>
	<tr>
		<th>Branch</th>
		<th>Manager</th>
		<th>Title</th>
		<th>Number</th>
		<th>Group / Level</th>
	</tr>
	<tr>
		<td>#position.branch_id#</td>
		<td>#position.manager_id#</td>
		<td>#position.title#</td>
		<td>#position.number#</td>
		<td>#position.group_level#</td>
	</tr>
</table>

<cfif history.recordcount EQ 0>
	<p>There are no entries in the staffing log for this position</p>
<cfelse>
	<ul>
	<cfloop query="history">
		<li>#history.user_name# #history.action# of the "#history.activity#" activity of the "#history.phase#" phase
		<cfif history.old_value neq ''>
			From "#history.old_value#"
		</cfif>
		 To "#history.new_value#" on #DateFormat(history.datetime,'mmm d, yyyy')# at #TimeFormat(history.datetime,'h:mm tt')#</li>
	</cfloop>
	</ul>
</cfif>

</cfoutput>