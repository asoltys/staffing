<cfquery name="master_query" datasource="#request.dsn#">
	SELECT
		staffing_users.id,
		common_login..users.first_name, 
		common_login..users.last_name,
		statuses.name AS status
	FROM common_login..users
	JOIN staffing_users
	ON common_login..users.login = staffing_users.login
	LEFT JOIN positions_users
	ON staffing_users.id = positions_users.user_id
	JOIN positions
	ON positions.id = positions_users.position_id
	LEFT JOIN processes
	ON positions.process_id = processes.id
	LEFT JOIN statuses
	ON statuses.id = processes.status_id
</cfquery>

<cfquery name="assistants" dbtype="query">
	SELECT id, first_name, last_name, count(*) as positions
	FROM master_query
	GROUP BY id, first_name, last_name
</cfquery>

<cfquery name="statuses" dbtype="query">
	SELECT DISTINCT status
	FROM master_query WHERE status IS NOT NULL
</cfquery>

<cfoutput>

<h1>HR Staff Report</h1>

<p>The following table indicates how many positions are assigned to each HR staff member, broken down by position status.</p>

<table>
	<tr>
		<th>&nbsp;</th>
		<cfloop query="statuses">
		<th>#statuses.status#</th>
		</cfloop>
		<th>Total</th>
	</tr>
	
	<cfloop query="assistants">
		<cfset assistant_id = assistants.id />
		
		<tr>
			<td>#assistants.first_name# #assistants.last_name#</td>
	
			<cfloop query="statuses">
				<cfset status = statuses.status />
			
				<cfquery name="positions" dbtype="query">
					SELECT *
					FROM master_query
					WHERE id = #assistant_id#
					AND (status = '#status#' OR ('#status#' = 'Not Started' AND status IS NULL))
				</cfquery>
				<td>#positions.recordcount#</td>
			</cfloop>
			<td>#assistants.positions#</td>
		</tr>
	</cfloop>
</table>

</cfoutput>