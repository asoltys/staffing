<cfcomponent extends="supermodel.DataModel">	
	<cffunction name="configure" access="public" returntype="void">
    <cfset addProperty('id', 'int') />
    <cfset addProperty('name', 'varchar') />

		<cfset variables.dsn = 'common_login' />
		<cfset variables.table_name = 'common_login..applications' />
		<cfset hasMany('users', getPath() & 'User', 'user') />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- selectQuery

	Description:
			
----------------------------------------------------------------------------------------------------->
	
	<cffunction name="selectQuery" access="private" returntype="query">
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				applications.id,
				applications.name,
				user_application_roles.user_id
			FROM applications
			LEFT JOIN user_application_roles
			ON applications.id = user_application_roles.application_id
			WHERE applications.id = 
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn query />
	</cffunction>
	
<!----------------------------------------------------------------------------------------- getPotentialUsers

	Description:	
	
---------------------------------------------------------------------------------------------------->	
<cffunction name="getPotentialUsers" access="public" returntype="supermodel.ObjectList">
	
	<cfset var query = '' />
	<cfset var list = createObject('component','supermodel.ObjectList') />
	<cfset var user = createObject('component','common_login.model.users.User') />
	<cfset user.init(variables.dsn) />
	
	<cfquery name="query" datasource="#variables.dsn#">
		SELECT users.*
		FROM users
		WHERE users.id NOT IN
		(
			SELECT user_id 
			FROM user_application_roles
			WHERE application_id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		)
		AND users.first_name !='' 
		AND users.last_name !=''
		AND users.deleted = 0
	</cfquery>

	<cfset list.init(user,query) />
	<cfset list.order('first_name','ASC') />
	<cfreturn list />
	
</cffunction>

<!----------------------------------------------------------------------------------------- getAssignedRoles

	Description:	
	
---------------------------------------------------------------------------------------------------->	
<cffunction name="getAssignedRoles" access="public" returntype="supermodel.ObjectList">
	
	<cfset var query = '' />
	<cfset var list = createObject('component','supermodel.ObjectList') />
	<cfset var role = createObject('component','common_login.modules.common_login.model.Role') />
	<cfset role.init(variables.dsn) />
	
	<cfquery name="query" datasource="#variables.dsn#">
		SELECT roles.*
		FROM roles
			JOIN applications_roles ON applications_roles.role_id = roles.id 
			AND applications_roles.application_id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />	
	</cfquery>

	<cfset list.init(role,query) />
	<cfreturn list />
	
</cffunction>

<!----------------------------------------------------------------------------------------- getRemainingRoles

	Description:	
	
---------------------------------------------------------------------------------------------------->	
<cffunction name="getRemainingRoles" access="public" returntype="supermodel.ObjectList">
	
	<cfset var query = '' />
	<cfset var list = createObject('component','supermodel.ObjectList') />
	<cfset var role = createObject('component','common_login.modules.common_login.model.Role') />
	<cfset role.init(variables.dsn) />
	
	<cfquery name="query" datasource="#variables.dsn#">
		SELECT roles.*
		FROM roles
		WHERE id NOT IN
			(
				SELECT role_id
				FROM applications_roles
				WHERE application_id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			)
	</cfquery>

	<cfset list.init(role,query) />
	<cfreturn list />
	
</cffunction>

<!----------------------------------------------------------------------------------------- getUsersByRole

	Description:	
	
---------------------------------------------------------------------------------------------------->	
<cffunction name="getUsersByRole" access="public" returntype="supermodel.ObjectList">
	<cfargument name="role" type="common_login.modules.common_login.model.Role" required="yes" />
	
	<cfset var query = '' />
	<cfset var list = createObject('component','supermodel.ObjectList') />
	<cfset var user = createObject('component','common_login.modules.common_login.model.User') />
	<cfset user.init(variables.dsn) />
	
	<cfquery name="query" datasource="#variables.dsn#">
		SELECT users.*
		FROM users
			JOIN user_application_roles ON user_application_roles.user_id = users.id
		WHERE user_application_roles.role_id = <cfqueryparam value="#arguments.role.id#" cfsqltype="cf_sql_integer" />
		AND user_application_roles.application_id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
	</cfquery>

	<cfset list.init(user,query) />
	<cfreturn list />
	
</cffunction>

<!----------------------------------------------------------------------------------------- addUser

	Description:	
	
---------------------------------------------------------------------------------------------------->	
<cffunction name="addUser" access="public" returntype="void">
	<cfargument name="user" type="common_login.modules.common_login.model.User" required="yes" />
	<cfargument name="role" type="common_login.modules.common_login.model.Role" required="yes" />
	
	<cfquery datasource="#variables.dsn#">
		INSERT INTO user_application_roles(user_id,role_id,application_id)
		Values
		(
			<cfqueryparam value="#arguments.user.user_id#" cfsqltype="cf_sql_integer" />,
			<cfqueryparam value="#arguments.role.id#" cfsqltype="cf_sql_integer" />,
			<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		)
	</cfquery>

</cffunction>

<!----------------------------------------------------------------------------------------- deleteUser

	Description:	
	
---------------------------------------------------------------------------------------------------->	
<cffunction name="deleteUser" access="public" returntype="void">
	<cfargument name="user" type="common_login.modules.common_login.model.User" required="yes" />
	
	<cfquery datasource="#variables.dsn#">
		DELETE
		FROM user_application_roles
		WHERE application_id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		AND user_id = <cfqueryparam value="#arguments.user.user_id#" cfsqltype="cf_sql_integer" />
	</cfquery>
	
</cffunction>

<!----------------------------------------------------------------------------------------- updateUserRole

	Description:	
	
---------------------------------------------------------------------------------------------------->	
<cffunction name="updateUserRole" access="public" returntype="void">
	<cfargument name="user" type="common_login.modules.common_login.model.User" required="yes" />
	<cfargument name="role" type="common_login.modules.common_login.model.Role" required="yes" />

	<cfquery datasource="#variables.dsn#">
		UPDATE user_application_roles
		SET role_id = <cfqueryparam value="#arguments.role.id#" cfsqltype="cf_sql_integer" />
		WHERE application_id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		AND user_id = <cfqueryparam value="#arguments.user.user_id#" cfsqltype="cf_sql_integer" />
	</cfquery>
	
</cffunction>
</cfcomponent>
