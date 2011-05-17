<cffunction name="dash" access="public" returntype="string">
	<cfargument name="number" type="numeric" required="yes" />
	
	<cfif number EQ 0>
		<cfreturn "-" />
	<cfelse>
		<cfreturn number />
	</cfif>
</cffunction>

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
		COALESCE(statuses.name, 'Not Started') AS status
	FROM positions
	JOIN tenures
		ON tenures.id = positions.tenure_id
	LEFT JOIN processes
	  ON processes.id = positions.process_id
	LEFT JOIN statuses
		ON statuses.id = processes.status_id
  LEFT JOIN positions_regions
    ON positions_regions.position_id = positions.id
  WHERE positions_regions.region_id = 
    <cfqueryparam value="#session.params.region_id#" cfsqltype="cf_sql_integer" />
</cfquery>

<cfoutput>

<h1>Tenure Breakdown</h1>

<table>
	<tr>
		<th>Type</th>
		<cfloop query="statuses">
		<th>#statuses.name#</th>
		</cfloop>
		<th>Total</th>
	</tr>
	
	<cfloop query="tenures">
		<cfset tenure = tenures.name />
		<cfset total = 0 />

		<tr>
			<td>#tenure#</td>
			<cfloop query="statuses">
				<cfset status = statuses.name />
				
				<cfquery name="positions" dbtype="query">
				SELECT *
				FROM master_query
				WHERE tenure =
					<cfqueryparam value="#tenure#" cfsqltype="cf_sql_varchar" />
				AND status = 
					<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfset total = total + positions.recordcount />
		
			<td>#dash(positions.recordcount)#</td>
			</cfloop>
			<td><strong>#dash(total)#</strong></td>
		</tr>
	</cfloop>
</table>


</cfoutput>
