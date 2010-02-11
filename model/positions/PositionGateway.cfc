<cfcomponent extends="supermodel.Gateway">

<!------------------------------------------------------------------------------------------ configure

	Description:	Carries out the configuration required for this object to act as a SuperModel
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.table_name = 'positions' />
	</cffunction>

<!--------------------------------------------------------------------------------------------- select

	Description:	Executes a SELECT query
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="select" access="public" returntype="query">
		<cfargument name="columns" default="*" />
		<cfargument name="tables" default="#variables.table_name#" />
		<cfargument name="conditions" default="" />
		<cfargument name="ordering" default="" />
		
		<cfset var query  = "" />
    <cfset var cachetime = CreateTimeSpan(0,0,0,0) />

    <cfif structKeyExists(session, 'params')>
      <cfset cachetime = CreateTimeSpan(1,0,0,0) />
    </cfif>

		<cfquery name="query" datasource="#variables.dsn#" cachedwithin="#cachetime#">
			SELECT
				positions.id,
				positions.manager_id,
				positions.fiscal_year,
				positions.process_id,
				positions.number,
				jobs.title AS job_title,
				classification_levels.name AS classification_level_name,
				classifications.name AS classification_name,
				common_login..branches.name AS branch_name,
				common_login..branches.acronym AS branch_acronym,
				cl_managers.first_name+' '+cl_managers.last_name as manager_name,
				statuses.name AS status_name,
				phases.name AS phase_name
			FROM positions
			LEFT JOIN processes 
				ON processes.id = positions.process_id
			LEFT JOIN statuses 
				ON processes.status_id = statuses.id
			LEFT JOIN phases 
				ON processes.phase_id = phases.id
			LEFT JOIN jobs 
				ON jobs.id = positions.job_id
			LEFT JOIN staffing_users managers 
				ON managers.id = positions.manager_id
			LEFT JOIN common_login..users cl_managers 
				ON managers.login = cl_managers.login
			JOIN common_login..branches 
				ON jobs.branch = common_login..branches.acronym
      JOIN common_login..locations
        ON positions.location = common_login..locations.name
      JOIN common_login..regions
        ON common_login..locations.region_id = common_login..regions.id
			JOIN classification_levels
				ON jobs.classification_level_id = classification_levels.id
			JOIN classifications
				ON classification_levels.classification_id = classifications.id
			<cfif arguments.conditions NEQ "">
			WHERE #PreserveSingleQuotes(arguments.conditions)#
			</cfif>
			<cfif arguments.ordering NEQ "">
			ORDER BY #arguments.ordering#
			</cfif>
		</cfquery>

		<cfreturn query />
	</cffunction>
</cfcomponent>
