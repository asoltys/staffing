<cfcomponent displayname="Role" extends="supermodel.DataModel">	
	<cffunction name="configure" access="public" returntype="void">
    <cfset addProperty('id', 'int') />
    <cfset addProperty('name', 'varchar') />
		<cfset variables.dsn = 'common_login' />
		<cfset variables.table_name = 'common_login..roles' />
		<cfset hasMany('users', getPath() & 'User', 'user') />
	</cffunction>

	
<!--------------------------------------------------------------------------------------- selectQuery

	Description:
			
----------------------------------------------------------------------------------------------------->
	
	<cffunction name="selectQuery" access="private" returntype="query">
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				roles.id,
				roles.name,
				user_application_roles.user_id
			FROM roles
			JOIN user_application_roles
			ON roles.id = user_application_roles.role_id
			WHERE roles.id = 
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn query />
	</cffunction>
</cfcomponent>
