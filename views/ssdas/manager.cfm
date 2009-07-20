<cfoutput> 

<table>
	<tr>
		<th>Phase</th>
		<th>Activity</th>
		<th>Status</th>
		<th>Estimated Completion Date</th>
		<th>Completion Date</th>
	</tr>
	<cfloop condition="#process_activities.next()#">
		<cfset process_activity = process_activities.current() />

		<tr class="#process_activity.getStatusClass(request.current_user)#">
			<td>#process_activity.activity.phase.name#</td>
			<td>#process_activity.activity.name#</td>
			<td>#process_activity.status.name#</td>		
			<td>#DateFormat(process_activity.est_completion_date, "yyyy-mm-dd")#</td>
			<td>#DateFormat(process_activity.completion_date, "yyyy-mm-dd")#</td>
		</tr>
	</cfloop>
</table>

<input id="return_to_log" type="button" value="Return to Staffing Log"  class="submitButton" style="width: 200px;" />
<br /><br />

</cfoutput>