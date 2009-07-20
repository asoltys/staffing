<cfoutput>

<p>
	<a id="add_activity" href="##" class="addLink">Add Activity</a>
</p>

<form action="#request.path#index.cfm?event=processes.updateSSDA" method="post" id="editSSDA">
	<input id="process_id" name="process_id" type="hidden" value="#process.id#" />

	<table>
		<tr>
			<th>Phase</th>
			<th style="width:50px;">Activity</th>
			<th>Status</th>
			<th>Estimated Completion Date (yyyy-mm-dd)</th>
			<th>Completion Date (yyyy-mm-dd)</th>
			<th style="width:80px;">At Risk Lead Time (days)</th>
			<th>&nbsp;</th>
		</tr>
		<cfloop condition="#process_activities.next()#">
			<cfset process_activity = process_activities.current() />

			<tr id="activity_#process_activity.id#" class="#process_activity.getStatusClass(request.current_user)#">
				<td>#process_activity.activity.phase.name#</td>
				<td>#process_activity.activity.name#</td>
				<td>
					<select id="status_id_#process_activity.id#" name="status_id_#process_activity.id#" class="status">
						<cfloop condition="#statuses.next()#">
							<cfset status = statuses.current() />

							<cfset selected = "" />
							<cfif status.id EQ process_activity.status_id>
								<cfset selected = "selected=""selected""" />
							</cfif>

							<option value="#status.id#" #selected#>#status.name#</option>
						</cfloop>
						<cfset statuses.reset() />
					</select>
				</td>
				<td>
					<input id="est_completion_date_#process_activity.id#" name="est_completion_date_#process_activity.id#" value="#LSDateFormat(process_activity.est_completion_date, 'yyyy-mm-dd')#" type="text" class="estimated_date date" />
					<img id="date_picker_#process_activity.id#" class="calendar" src="#request.path#images/calendar.gif" />
				</td>
				<td>
					<input id="completion_date_#process_activity.id#" name="completion_date_#process_activity.id#" value="#LSDateFormat(process_activity.completion_date, 'yyyy-mm-dd')#" type="text" class="completion_date date"/>
					<img id="date_picker_#process_activity.id#" class="calendar" src="#request.path#images/calendar.gif" />
				</td>
				<td>
					<input id="endangered_time_#process_activity.id#" name="endangered_time_#process_activity.id#" value="#process_activity.endangered_time#" type="text" class="endangeredTime"/>
				</td>
				<td>
					<a id="delete_activity_#process_activity.id#" class="delete_activity">N/A</a>
				</td>
			</tr>
		</cfloop>
	</table>

	<input type="submit" value="Update SSDA" class="submitButton" style="float: left;" />
	<input id="return_to_log" type="button" value="Return to Staffing Log"  class="submitButton" style="width: 200px;" />
</form>

</cfoutput>
