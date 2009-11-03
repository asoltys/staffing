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
				pools.classification_level_id,
				pools.expiry_date,
				pools.description,
				processes.number AS process_number,
				classification_levels.name AS classification_level_name,
				classifications.name AS classification_name,
				common_contacts.first_name AS contact_first_name,
				common_contacts.last_name AS contact_last_name,
        common_contacts.email AS contact_email
			FROM pools
			LEFT JOIN processes
				ON processes.id = pools.process_id
			LEFT JOIN staffing_users contacts
				ON contacts.id = pools.contact_id
			LEFT JOIN classification_levels
				ON classification_levels.id = pools.classification_level_id
			LEFT JOIN classifications
				ON classifications.id = classification_levels.classification_id
			LEFT JOIN common_login..users common_contacts
				ON common_contacts.login = contacts.login
		</cfquery>
		
		<cfreturn query />
	</cffunction>
</cfcomponent>
