<cfcomponent extends="supermodel.Gateway">
	<cffunction name="configure">
		<cfset variables.table_name = 'pools' />
	</cffunction>
	
<!--------------------------------------------------------------------------------------------- select

	Description:
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="select" access="public" returntype="query">
		<cfargument name="columns" default="*" />
		<cfargument name="tables" default="#variables.table_name#" />
		<cfargument name="conditions" default="" />
		<cfargument name="ordering" default="" />
		
		<cfset var query  = "" />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT
				pools.id,
				pools.process_id,
				pools.contact_id,
        pools.creation_date,
				pools.expiry_date,
				pools.description,
        positions.region_id,
        positions.location,
        positions.title,
        positions.language,
				processes.number AS process_number,
				classification_levels.name AS classification_level_name,
				classifications.name AS classification_name,
				common_contacts.first_name AS contact_first_name,
				common_contacts.last_name AS contact_last_name,
        common_contacts.email AS contact_email
			FROM pools
      LEFT JOIN (
        SELECT DISTINCT
          positions.process_id,
          positions.location,
          jobs.title,
          jobs.classification_level_id,
          language_considerations.name as language,
          positions_regions.region_id
        FROM positions
        LEFT JOIN jobs ON jobs.id = positions.job_id
        LEFT JOIN language_considerations ON language_considerations.id = positions.language_consideration_id
        LEFT JOIN positions_regions ON positions_regions.position_id = positions.id
      ) positions ON pools.process_id = positions.process_id
			LEFT JOIN processes
				ON processes.id = pools.process_id
			LEFT JOIN staffing_users contacts
				ON contacts.id = pools.contact_id
			LEFT JOIN classification_levels
				ON classification_levels.id = positions.classification_level_id
			LEFT JOIN classifications
				ON classifications.id = classification_levels.classification_id
			LEFT JOIN common_login..users common_contacts
				ON common_contacts.login = contacts.login
      <cfif structKeyExists(session, 'params') and structKeyExists(session.params, 'region_id')>
      WHERE positions.region_id = 
        <cfqueryparam value="#session.params.region_id#" cfsqltype="cf_sql_integer" />
      </cfif>
		</cfquery>
		
		<cfreturn query />
	</cffunction>
</cfcomponent>
