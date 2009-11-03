<!-------------------------------------------------------------------------------------------- User

	Description:	This common user object provides methods like getBranch() or getRoles() which are
                methods specific to the common login application.  It also extends the DataModel
                although initialization is left up to the client application's user object.  
	
---------------------------------------------------------------------------------------------------->

<cfcomponent extends="supermodel.DataModel">

<!------------------------------------------------------------------------------------------ configure

	Description:	Configures the basic variables required by the object.  Note: It is MANDATORY for the
								client user object to set variables.application_name within its own configure method.
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="configure" access="public" returntype="void" >				
		
    <cfset addProperty('id', 'int','common_login_fields') />
    <cfset addProperty('login', 'varchar','common_login_fields') />
    <cfset addProperty('password', 'varchar','common_login_fields') />
    <cfset addProperty('first_name', 'varchar','common_login_fields') />
    <cfset addProperty('last_name', 'varchar','common_login_fields') />
    <cfset addProperty('title', 'varchar','common_login_fields') />
    <cfset addProperty('branch_id', 'int','common_login_fields') />
    <cfset addProperty('location', 'varchar','common_login_fields') />
    <cfset addProperty('phone', 'varchar','common_login_fields') />
    <cfset addProperty('email', 'varchar','common_login_fields') />
    <cfset addProperty('fax', 'varchar','common_login_fields') />
    <cfset addProperty('failed_once', 'bit','common_login_fields') />
    <cfset addProperty('image', 'varchar','common_login_fields') />
    <cfset addProperty('keep', 'bit','common_login_fields') />
    <cfset addProperty('deleted', 'bit','common_login_fields') />

		<cfset variables.common_login_dsn = "common_login" />
		<cfset variables.table_name = "users" />
		<cfset belongsTo('role', getPath() & 'Role') />
		<cfset belongsTo('application', getPath() & 'Application') />
		<cfset belongsTo('branch', getPath() & 'Branch') />
		<cfset hasMany('applications', getPath() & 'Application','application') />
		<cfset hasMany('committees', getPath() & 'Committee','committee') />
		<cfset hasMany('roles', getPath() & 'Role','role') />
		
		<cfset this.role_id = "" />
		<cfset this.application_id = "" />
		<cfset this.branch_id = "" />
		<cfset this.user_id = "" />
	</cffunction>
  
<!---------------------------------------------------------------------------------------------- init

	Description:	Constructs the object by reading all the columns from the database and creating 
								private member variables for each field.
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="init">
		<cfargument name="dsn" type="string" required="yes" hint="The datasource name" />
		<cfargument name="application_name" type="string" required="no" />
		<cfargument name="table_name" type="string" required="no" />
	
		<cfset super.init(arguments.dsn) />
			
		<cfif structKeyExists(arguments,'application_name')>
			<cfset variables.application_name = arguments.application_name />
		</cfif>
		<cfif structKeyExists(arguments,'table_name')>
			<cfset variables.table_name = arguments.table_name />
		</cfif>
	</cffunction>

<!------------------------------------------------------------------------------ readOrCreateFromLogin

	Description:	Uses the user's unique login name to read in their data from the database as opposed
								to the usual method of reading from their id.
			
----------------------------------------------------------------------------------------------------->

	<cffunction name="readOrCreateFromLogin" access="public" returntype="void">
		<cfargument name="login" type="string" required="yes" />

		<cfquery name="getUser" datasource="#variables.dsn#">
			SELECT #variables.table_name#.id
			FROM #variables.table_name#
			WHERE #variables.table_name#.login = 
				<cfqueryparam value="#Trim(arguments.login)#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<!--- 
			If the user doesn't exist in the client application 
			database then we create them 
		--->
		<cfif getUser.recordCount EQ 0>
			<cfset this.login = arguments.login />
			<cfset create() />
			<cfset read(this.id) />
		<cfelse>
			<cfset read(getUser.id) />
		</cfif>

	</cffunction>
	
<!-------------------------------------------------------------------------------------------- getName

	Description:	Returns the user's full name
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getName" access="public" returntype="string">
		<cfreturn this.first_name & " " & this.last_name />
	</cffunction>
	
<!--------------------------------------------------------------------------------- getApplicationName

	Description:	Returns the application that the user is being authenticated against
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getApplicationName" access="public" returntype="string">
		<cfreturn variables.application_name />
	</cffunction>

<!----------------------------------------------------------------------------------- isAuthenticated

	Description:	Returns true if the user is authenticated, false otherwise.
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="isAuthenticated" access="public" returntype="boolean" 
		hint="Returns true if the user is logged into the system">
		
		<!---
			If the user's login was not put in the Session by 
			common_login then the user is not logged in 
		--->
		<cfif NOT structKeyExists(session, 'login')>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />
	</cffunction>
	
<!---------------------------------------------------------------------------------------------- read

	Description:	Takes in an ID and reads the data from the database into this object.
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="read" access="public" returntype="void">
		<cfargument name="id" required="yes" />	
		
		<cfset var query = "" />
		<cfset var params = StructNew() />
		<cfset var prefix = "" />

		<cfset this.id = arguments.id />
		
		<cfif structKeyExists(this, 'prefix')>
			<cfset prefix = this.prefix />
		</cfif>
		
		<!--- Get the username from the parent app --->
		<cfquery name="getLogin" datasource="#variables.dsn#">
			SELECT login
			FROM #variables.table_name#
			WHERE #variables.table_name#.id =
				<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
												
		<!--- Read the common login user attributes --->
		<cfquery name="query" datasource="#variables.common_login_dsn#">
			SELECT
				#arguments.id# AS id,
				users.id AS user_id,
				users.login,
				users.location,
				users.branch_id,
				users.first_name,
				users.last_name,
				users.title,
				users.email,
				users.phone,
				users.fax,
				users.failed_once,
				branches.id AS branch_id
			FROM users
			JOIN branches
				ON branches.id = users.branch_id
			WHERE users.login = 
				<cfqueryparam value="#getLogin.login#" cfsqltype="cf_sql_varchar" />
			AND users.deleted = 0		
		</cfquery>
		
		<cfloop list="#query.columnlist#" index="column">
			<cfset StructInsert(params, prefix & column, Evaluate("query.#column#"), true) />
		</cfloop>

		<cfif structKeyExists(variables,'application_name')>
			<cfquery name="getRole" datasource="#variables.common_login_dsn#">
				SELECT roles.id
				FROM roles
				JOIN user_application_roles
					ON user_application_roles.role_id = roles.id
				JOIN applications 
					ON applications.id = user_application_roles.application_id
				JOIN users
					ON users.id = user_application_roles.user_id
				WHERE users.login = 
					<cfqueryparam value="#getLogin.login#" cfsqltype="cf_sql_varchar" />
				AND applications.name =
					<cfqueryparam value="#variables.application_name#" cfsqltype="cf_sql_varchar" />
					
			</cfquery>
			<cfquery name="getApplication" datasource="#variables.common_login_dsn#">
				SELECT applications.id
				FROM applications
				WHERE applications.name = 
					<cfqueryparam value="#variables.application_name#" cfsqltype="cf_sql_varchar" />				
			</cfquery>
			
			<cfif getRole.recordcount GT 0>
				<cfset this.role_id = getRole.id />
			</cfif>

			<cfif getApplication.recordcount GT 0>
				<cfset this.application_id = getApplication.id />
			</cfif>
		</cfif>
	
		<!--- When we load the params we want the id to be from the parent application's users table --->
		<cfset params.id = arguments.id />

		<!--- Load the combined application-specific and common_login user params --->
 		<cfset load(params) />
		
		<!--- Read the application-specific user attributes --->
		<cfset super.read(arguments.id) />
	</cffunction>
	
<!------------------------------------------------------------------------------------- getApplication

	Description:	
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="getApplication" access="public" returntype="string">
		<cfreturn variables.application_name />
	</cffunction>
	
<!------------------------------------------------------------------------------------------ getBranch

	Description:	
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="getBranch" access="public" returntype="Branch">
		<cfset var branch = createObject('component', 'Branch') />
		
		<cfset branch.init(variables.dsn) />
		<cfset branch.read(this.branch) />
		
		<cfreturn branch />
	</cffunction>
	
<!------------------------------------------------------------------------------ deleteFromApplication

	Description:	Delete the user from the user_application_roles table and call the parent delete
								method to delete them from the users table in the parent application
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="deleteFromApplication" access="public" returntype="void">
		<cfset super.delete() />
		
		<cfquery datasource="#variables.common_login_dsn#">
			DELETE FROM user_application_roles
			WHERE user_id = 
				<cfqueryparam value="#this.user_id#" cfsqltype="cf_sql_integer" />
			AND application_id = 
				<cfqueryparam value="#this.application_id#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>
		
<!----------------------------------------------------------------------------------------- updateRole

	Description:
			
----------------------------------------------------------------------------------------------------->	
  
  <cffunction name="updateRole" access="public" returntype="void">   
		<cfset var user_query = "" />
		
		<cfquery datasource="#variables.common_login_dsn#">
			UPDATE user_application_roles
			SET role_id = 
				<cfqueryparam value="#this.role.id#" cfsqltype="cf_sql_integer" />
			WHERE user_id = 
				<cfqueryparam value="#this.user_id#" cfsqltype="cf_sql_integer" />
			AND application_id = 
				<cfqueryparam value="#this.application.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
  </cffunction>
	
<!-------------------------------------------------------------------------------------------- hasRole

	Description:
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="hasRole" access="public" returntype="boolean">
		<cfargument name="roles" type="string" required="yes" />

    <cfset var query = '' />

    <cfif this.id EQ "">
      <cfreturn false />
    </cfif>

    <cfquery name="query" datasource="#variables.common_login_dsn#">
      SELECT count(*) as numrecords
      FROM user_application_roles
      JOIN roles
      ON user_application_roles.role_id = roles.id
      WHERE user_application_roles.user_id = <cfqueryparam value="#this.user_id#" cfsqltype="cf_sql_integer">
      AND roles.name IN (<cfqueryparam value="#arguments.roles#" list="yes" cfsqltype="cf_sql_varchar">)
    </cfquery>

		<cfreturn query.numrecords GT 0>
	</cffunction>
	
		
<!----------------------------------------------------------------------------------- readApplications

	Description:
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="readApplications" access="public" returntype="void">
	
		<cfset var query = '' />

		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				applications.id as application_id,
				applications.name as application_name
			FROM
				users
				JOIN user_application_roles ON user_application_roles.user_id = users.id
				JOIN applications ON user_application_roles.application_id = applications.id
			WHERE users.id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset this.applications.setQuery(query) />
	</cffunction>
	
<!----------------------------------------------------------------------------------------- readRoles

	Description:
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="readRoles" access="public" returntype="void">
	
		<cfset var query = '' />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				roles.id as role_id,
				roles.name as role_name
			FROM
				users
				JOIN user_application_roles ON user_application_roles.user_id = users.id
				JOIN roles ON user_application_roles.role_id = roles.id
			WHERE users.id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset this.roles.setQuery(query) />
	</cffunction>
	
<!------------------------------------------------------------------------------------------- getRole

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getRole" access="public" returntype="supermodel.DataModel">
		<cfargument name="application" type="any" />
		
		<cfset var query = '' />
		<cfset var role = createObject('component',getPath()& 'Role') />
		<cfset role.init(variables.dsn) />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT roles.*
			FROM roles
			JOIN user_application_roles ON user_application_roles.role_id = roles.id
			AND user_application_roles.user_id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			AND user_application_roles.application_id = <cfqueryparam value="#arguments.application.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfset role.load(query) />
		<cfreturn role />
	</cffunction>
	
<!------------------------------------------------------------------------------------- readCommittees

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="readCommittees" access="public" returntype="void">
	
		<cfset var query = '' />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				committees.id as committee_id,
				committees.name as committee_name,
				committees.acronym as committee_acronym
			FROM committees
				JOIN users_committees ON committees.id = users_committees.committee_id
			WHERE users_committees.user_id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset this.committees.setQuery(query) />
	
	</cffunction>
</cfcomponent>
