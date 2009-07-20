<cfcomponent>
	<cfset init() />
	
	<cffunction name="init" access="private" returntype="void" output="false">
		<cfset variables.dsn = 'hr_staffing' />
		<cfset variables.application_name = 'HR Portal' />
		
		<cfset variables.user = createObject('component', 'hr_staffing.model.users.user') />
		<cfset variables.user.configure() />
		<cfset variables.user.init(variables.dsn) />
		
		<cfset variables.userGateway = createObject('component', 'hr_staffing.model.users.userGateway') />	
		<cfset variables.userGateway.configure() />
		<cfset variables.userGateway.init(variables.dsn) />
	</cffunction>
	
	<cffunction name="getUser" access="remote" returntype="hr_staffing.model.users.user" output="false">
		<cfargument name="login" type="string" required="yes" />
		<cfset variables.user.readOrCreateFromLogin(arguments.login) />
		
		<cfreturn variables.user />
	</cffunction>
	
	<cffunction name="getUsers" access="remote" returntype="array" output="true"> 
		<cfset var user_query = variables.userGateway.select() />
		<cfset var user_list = createObject('component', 'supermodel.objectlist') />
		<cfset var user_array = ArrayNew(1) />

		<cfset user_list.init(
			variables.user,
			user_query) />
			
		<cfset user_array = user_list.toArray() />
	
		<cfreturn user_array />
	</cffunction>
	
	<cffunction name="getPotentialUsers" access="remote" returntype="array" output="true"> 
		<cfset var user_query = '' />
		<cfset var user_list = '' />
		<cfset var user_array = ArrayNew(1) />
		<cfset var gateway = createObject('component','common_login.model.users.UserGateway') />
		<cfset gateway.init("common_login") />
		<cfset user_query = gateway.usersNotInApplication(application_name="#variables.application_name#") />

		<cfset user_list = createObject('component', 'supermodel.objectlist') />

		<cfset user_list.init(
			user,
			user_query) />
			
		<cfset user_array = user_list.toArray() />
	
		<cfreturn user_array />
	</cffunction>
	
	<cffunction name="addUser" access="remote" returntype="User" output="false">
		<cfargument name="user" type="hr_staffing.model.users.user" required="yes" />
		
		<cfset var common_user = createObject('component','common_login.model.users.User') />
		<cfset common_user.configure() />
		<cfset common_user.init('common_login') />
		
		<cfset common_user.id = arguments.user.id />
		<cfset common_user.setRole(
			application_name = variables.application_name,
			role = arguments.user.role.name) />
		
		<cfset arguments.user.configure() />
		<cfset arguments.user.init(variables.dsn) />
		<cfset arguments.user.addUser() />
				
		<cfreturn arguments.user />
		
	</cffunction>
	
	<cffunction name="deleteUser" access="remote" returntype="void" output="false">
		<cfargument name="user" type="hr_staffing.model.users.user" required="yes" />
		
		<cfset var common_user = createObject('component','common_login.model.users.User') />
		<cfset common_user.configure() />
		<cfset common_user.init('common_login') />
		<cfset common_user.id = arguments.user.id />
		<cfset common_user.deleteUserFromApplication(application_name='#variables.application_name#') />
		<cfset arguments.user.configure() />
		<cfset arguments.user.init(variables.dsn) />
		<cfset arguments.user.deleteUser() />
		
	</cffunction>
	
</cfcomponent>