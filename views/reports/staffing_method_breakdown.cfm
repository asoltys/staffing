<cffunction name="dash" access="public" returntype="string">
	<cfargument name="number" type="numeric" required="yes" />
	
	<cfif number EQ 0>
		<cfreturn "-" />
	<cfelse>
		<cfreturn number />
	</cfif>
</cffunction>

<cfquery name="staffing_methods" datasource="#request.dsn#">
	SELECT id, name
	FROM staffing_methods
</cfquery>

<cfquery name="tenures" datasource="#request.dsn#">
	SELECT id, name
	FROM tenures
</cfquery>

<cfquery name="statuses" datasource="#request.dsn#">
	SELECT id, name
	FROM statuses
</cfquery>

<cfquery name="master_query" datasource="#request.dsn#">
	SELECT 
		tenures.name as tenure, 
		staffing_methods.name as staffing_method,
		COALESCE(statuses.name, 'Not Started') AS status
	FROM positions
	JOIN tenures
		ON tenures.id = positions.tenure_id
	LEFT JOIN processes
	  ON processes.id = positions.process_id
	JOIN staffing_methods
		ON staffing_methods.id = processes.staffing_method_id
	LEFT JOIN statuses
		ON statuses.id = processes.status_id
</cfquery>

<cfoutput>

<h1>Staffing Method Breakdown</h1>

<table>
	<tr>
		<th>Type</th>
		<cfloop query="statuses">
		<th>#statuses.name#</th>
		</cfloop>
		<th>Total</th>
	</tr>
	
	<cfloop query="staffing_methods">
		<cfset staffing_method = staffing_methods.name />
		<cfset total = 0 />

		<tr style="background-color: ##ddd;">
			<td><strong>#staffing_method#</strong></td>
			<cfloop query="statuses">
				<cfset status = statuses.name />
				
				<cfquery name="positions" dbtype="query">
				SELECT *
				FROM master_query
				WHERE staffing_method =
					<cfqueryparam value="#staffing_method#" cfsqltype="cf_sql_varchar" />
				AND status = 
					<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfset total = total + positions.recordcount />
		
			<td>#dash(positions.recordcount)#</td>
			</cfloop>
			<td><strong>#dash(total)#</strong></td>
		</tr>
		
		<cfloop query="tenures">
			<cfset total = 0 />
			<cfset tenure = tenures.name />
			
			<tr>
				<td>#tenure#</td>
				<cfloop query="statuses">
					<cfset status = statuses.name />
					
					<cfquery name="positions" dbtype="query">
						SELECT *
						FROM master_query
						WHERE staffing_method =
							<cfqueryparam value="#staffing_method#" cfsqltype="cf_sql_varchar" />
						AND status = 
							<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar" />
						AND tenure =
							<cfqueryparam value="#tenure#" cfsqltype="cf_sql_varchar" />
					</cfquery>
					
					<cfset total = total + positions.recordcount />
				
					<td>#dash(positions.recordcount)#</td>
				</cfloop>
				<td>#dash(total)#</td>
			</tr>
		</cfloop>
	</cfloop>
</table>


</cfoutput>