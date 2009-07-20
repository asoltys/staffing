<cfquery name="staffing_methods" datasource="#request.dsn#">
	SELECT id, name
	FROM staffing_methods
</cfquery>

<cfquery name="tenures" datasource="#request.dsn#">
	SELECT id, name
	FROM tenures
</cfquery>

<cfquery name="unstaffed_positions" datasource="#request.dsn#">
	SELECT 
		tenures.name as tenure, 
		staffing_methods.name as staffing_method
	FROM positions
	JOIN staffing_methods
		ON staffing_methods.id = positions.staffing_method_id
	JOIN tenures
		ON tenures.id = positions.tenure_id
	WHERE (
		SELECT count(*)
		FROM processes_staffing_activities
		WHERE processes_staffing_activities.status_id != 3
		AND processes_staffing_activities.process_id = positions.id
	) != 0
</cfquery>

<cfquery name="staffed_positions" datasource="#request.dsn#">
	SELECT 
		tenures.name as tenure, 
		staffing_methods.name as staffing_method
	FROM positions
	JOIN staffing_methods
		ON staffing_methods.id = positions.staffing_method_id
	JOIN tenures
		ON tenures.id = positions.tenure_id
	WHERE (
		SELECT count(*)
		FROM processes_staffing_activities
		WHERE processes_staffing_activities.status_id != 3
		AND processes_staffing_activities.process_id = positions.id
	) = 0
</cfquery>

<cfoutput>

<h1>Bird's Eye View</h1>

<table>
	<tr>
		<th colspan="4">Positions</th>
	</tr>
	
	<tr>
		<th>Type</th>
		<th>Staffed</th>
		<th>Unstaffed</th>
		<th>Total</th>
	</tr>
	
	<cfloop query="staffing_methods">
		<cfset staffing_method = staffing_methods.name />
		
		<cfquery name="staffed" dbtype="query">
			SELECT *
			FROM staffed_positions
			WHERE staffing_method =
				<cfqueryparam value="#staffing_method#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfquery name="unstaffed" dbtype="query">
			SELECT *
			FROM unstaffed_positions
			WHERE staffing_method =
				<cfqueryparam value="#staffing_method#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfset total = staffed.recordcount + unstaffed.recordcount />
	
		<tr>
			<td><strong>#staffing_methods.name#</strong></td>
			<td>#staffed.recordcount#</td>
			<td>#unstaffed.recordcount#</td>
			<td>#total#</td>
		</tr>
		
		<cfloop query="tenures">
			<cfquery name="staffed" dbtype="query">
				SELECT *
				FROM staffed_positions
				WHERE staffing_method =
					<cfqueryparam value="#staffing_method#" cfsqltype="cf_sql_varchar" />
				AND tenure = 
					<cfqueryparam value="#tenures.name#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfquery name="unstaffed" dbtype="query">
				SELECT *
				FROM unstaffed_positions
				WHERE staffing_method =
					<cfqueryparam value="#staffing_method#" cfsqltype="cf_sql_varchar" />
				AND tenure = 
					<cfqueryparam value="#tenures.name#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfset total = staffed.recordcount + unstaffed.recordcount />
		
			<tr>
				<td>#tenures.name#</td>
				<td>#staffed.recordcount#</td>
				<td>#unstaffed.recordcount#</td>
				<td>#total#</td>
			</tr>
		</cfloop>
	</cfloop>
	
	<cfset total = staffed_positions.recordcount + unstaffed_positions.recordcount />
	
	<tr>
		<td><strong>Total</strong></td>
		<td>#staffed_positions.recordcount#</td>
		<td>#unstaffed_positions.recordcount#</td>
		<td>#total#</td>
	</tr>

</table>


</cfoutput>