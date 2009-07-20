<cfcomponent extends="hr_staffing.modules.common_login.model.UserGateway">

<!------------------------------------------------------------------------------------------ configure

	Description:	Carries out the configuration required for this object to act as a SuperModel
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.table_name = 'staffing_users' />
		<cfset variables.application_name = 'HR Staffing' />
	</cffunction>
	
<!--------------------------------------------------------------------------------------------- select

	Description:	Executes a SELECT query
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="select" access="public" returntype="query" output="false">
		<cfargument name="columns" default="*" />
		<cfargument name="tables" default="#variables.table_name#" />
		<cfargument name="conditions" default="1=1" />
		<cfargument name="ordering" default="common_login..users.first_name" />
		
		<cfset var query  = "" />

		<cfquery name="query" datasource="#variables.dsn#">
			SELECT
				#variables.table_name#.id,
				#variables.table_name#.login,
				common_login..users.first_name,
				common_login..users.last_name,
				common_login..user_application_roles.role_id
			FROM #variables.table_name#
			JOIN common_login..users
				ON #variables.table_name#.login = common_login..users.login
			JOIN common_login..applications 
				ON common_login..applications.name = 
					<cfqueryparam value="#variables.application_name#" cfsqltype="cf_sql_varchar" />
			JOIN common_login..user_application_roles
				ON common_login..user_application_roles.user_id = common_login..users.id
				AND common_login..user_application_roles.application_id = common_login..applications.id
			JOIN common_login..roles
				ON common_login..roles.id = common_login..user_application_roles.role_id
			WHERE #PreserveSingleQuotes(arguments.conditions)#
			ORDER BY #arguments.ordering#
		</cfquery>

		<cfreturn query />
	</cffunction>
		
</cfcomponent>
