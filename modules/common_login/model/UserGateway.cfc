<cfcomponent displayname="UserGateway" extends="supermodel.Gateway">

<!------------------------------------------------------------------------------------------ configure

	Description:	Carries out the configuration required for this object to act as a SuperModel
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.table_name = 'users' />
	</cffunction>
	
<!--------------------------------------------------------------------------------------------- select

	Description:	Executes a SELECT query
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="select" access="public" returntype="query">
		<cfargument name="columns" default="*" />
		<cfargument name="tables" default="#variables.table_name#" />
		<cfargument name="conditions" default="1=1" />
		<cfargument name="ordering" default="common_login..users.first_name" />
		
		<cfset var query  = "" />

		<cfquery name="query" datasource="#variables.dsn#">
			SELECT
				users.id,
				users.login,
				common_login..users.first_name,
				common_login..users.last_name,
				common_login..users.branch,
				user_application_roles.role_id
			FROM users
			JOIN users
				ON common_login..users.login = users.login
			JOIN applications 
				ON applications.name =
					<cfqueryparam value="#application.applicationname#" cfsqltype="cf_sql_varchar" />
			JOIN user_application_roles
				ON user_application_roles.user_id = common_login..users.id
				AND user_application_roles.application_id = applications.id
			WHERE #arguments.conditions#
			AND deleted = 0
			ORDER BY #arguments.ordering#
		</cfquery>
		
		<cfthrow message="#arguments.conditions#" />

		<cfreturn query />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- selectByRole

	Description:	Executes a SELECT query, narrowed by user's role
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="selectByRole" access="public" returntype="query">
		<cfargument name="role" type="string" required="yes" />
		
		<cfset var query = "" />
		<cfset var conditions = "" />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT id FROM common_login..roles WHERE name =
				<cfqueryparam value="#arguments.role#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfset conditions = "common_login..user_application_roles.role_id = " & query.id />
		
		<cfreturn select(conditions = conditions) />
	</cffunction>
	
<!-------------------------------------------------------------------------------- usersInApplication

	Description:  Returns a query of all users belonging to the given application
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="usersInApplication" access="public" returntype="query">
		<cfargument name="application_name" type="string" required="no" />
				
		<cfset var SelectUsers = "" />

		<cfquery name="SelectUsers" datasource="#variables.dsn#">
			SELECT common_login..users.*, common_login..roles.name as role, common_login..roles.id as common_login..role_id
			FROM users
			JOIN common_login..user_application_roles 
				ON common_login..user_application_roles.user_id = common_login..users.id
			JOIN common_login..applications 
				ON common_login..user_application_roles.application_id = common_login..applications.id
			JOIN common_login..roles 
				ON common_login..user_application_roles.role_id = common_login..roles.id
			WHERE common_login..applications.name =
				<cfqueryparam value="#arguments.application_name#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfreturn SelectUsers />
	</cffunction>			
	
<!---------------------------------------------------------------------------- usersNotInApplication

	Description:  Returns a query of all users belonging to the given application
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="usersNotInApplication" access="public" returntype="query">
		<cfargument name="application_name" type="string" required="no" />
				
		<cfset var SelectUsers = "" />

		<cfquery name="SelectUsers" datasource="#variables.dsn#">
			SELECT common_login..users.*
			FROM common_login..users
			WHERE common_login..users.id NOT IN (
				SELECT user_id 
				FROM common_login..user_application_roles
				JOIN common_login..applications 
					ON common_login..user_application_roles.application_id = common_login..applications.id
				WHERE common_login..applications.name =
					<cfqueryparam value="#arguments.application_name#" cfsqltype="cf_sql_varchar" />
			)
			AND users.deleted = 0
			ORDER BY common_login..users.last_name
		</cfquery>

		<cfreturn SelectUsers />
	</cffunction>			
</cfcomponent>
