<cfcomponent extends="MachII.framework.Listener">

<!----------------------------------------------------------------------------------------- configure

	Description:	
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="configure" access="public" output="false" returntype="void" 
		hint="Configures this listener as part of the Mach-II framework">
  </cffunction>
	
<!-------------------------------------------------------------------------------------- prepareForm

	Description:	Puts an object in the event
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var user = createObject('component','common_login.modules.common_login.model.User') />
		<cfset var app = request.current_user.application />
		<cfset var roles = app.getAssignedRoles() />
		<cfset user.init(request.dsn,app.name,request.current_user.getTableName()) />
		<cfset user.readOrCreateFromLogin(event.getArg('login')) />

		<cfset event.setArg('user',user) />
		<cfset event.setArg('roles',roles) />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- prepareList

	Description:	Returns a query of all the entities
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareList" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var app = request.current_user.application />
		<cfset var roles = app.getAssignedRoles() />
		<cfset var potential_users = app.getPotentialUsers() />
		<cfset var potential_roles = app.getAssignedRoles() />
		
		<cfset potential_users.order('first_name, last_name') />
		
		<cfset event.setArg('app', app) />
		<cfset event.setArg('roles', roles) />
		<cfset event.setArg('potential_users', potential_users) />
		<cfset event.setArg('potential_roles', potential_roles) />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- processForm

	Description:	Validate the form then either create or update the object.
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="processForm" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var app = request.current_user.application />
		<cfset var user_login = event.getArg('login') />
		<cfset var role_id = event.getArg('role_id') />
		<cfset var user = createObject('component','common_login.modules.common_login.model.User') />
		<cfset var role = createObject('component','common_login.modules.common_login.model.Role') />
		<cfset user.init(request.dsn,app.name,request.current_user.getTableName()) />
		<cfset role.init(request.dsn) />
		
		<cfset user.readOrCreateFromLogin(user_login) />
		<cfset role.read(role_id) />

		<cfset app.updateUserRole(user,role) />
		<cfset announceEvent('users.list') />
	</cffunction>
	
<!---------------------------------------------------------------------------------------- processAdd

	Description:	Adds a new user from the pool of potential users
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="processAdd" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var user = createObject('component','common_login.modules.common_login.model.User') />
		<cfset var role = createObject('component','common_login.modules.common_login.model.Role') />
		<cfset var user_logins = event.getArg('user_logins') />
		<cfset var role_id = event.getArg('role_id') />
		<cfset var app = request.current_user.application />
		<cfset user.init(request.dsn,app.name,request.current_user.getTableName()) />
		<cfset role.init(request.dsn) />
		<cfset role.read(role_id) />

		<cfloop list="#user_logins#" index="user_login">
			<cfset user.readOrCreateFromLogin(user_login) />	
			<cfset app.addUser(user,role) />
		</cfloop>
		
		<cfset announceEvent('users.list') />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- processDelete

	Description:	Delete the object
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="processDelete" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var app = request.current_user.application />
		<cfset var user = createObject('component','common_login.modules.common_login.model.User') />
		<cfset user.init(request.dsn,app.name,request.current_user.getTableName()) />
    	<cfset user.readOrCreateFromLogin(arguments.event.getArg('login')) />
		
		<cfif structKeyExists(session, 'login') AND user.login EQ session.login>
			<cfset event.setArg('error', "You can't delete yourself") />
		<cfelse>
			<cfset user.delete() />
			<cfset app.deleteUser(user) />
		</cfif>
		
		<cfset announceEvent('users.list', event.getArgs()) />
	</cffunction>	
</cfcomponent>
