<cfquery name="activities" datasource="#request.dsn#">
	SELECT 
		staffing_activities.id,
		staffing_activities.name
	FROM staffing_activities
	WHERE staffing_activities.id NOT IN (
		SELECT activity_id
		FROM processes_staffing_activities
		WHERE processes_staffing_activities.process_id =
			<cfqueryparam value="#URL.process_id#" cfsqltype="cf_sql_integer" />
	)
</cfquery>

<cfoutput>

<cfif activities.recordcount EQ 0>
	<p>
		There are no activities remaining to be added
	</p>
<cfelse>
	<label for="activity_id">Activities</label>
	<select name="activity_id" id="activity_id">
		<option value="">Select One</option>
		<cfloop query="activities">
			<option value="#activities.id#">#activities.name#</option>
		</cfloop>
	</select>
</cfif>

</cfoutput>