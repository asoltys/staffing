<cfcomponent>
	<cffunction name="init" access="public" returntype="void" output="false">
		<cfargument name="object" type="any" required="yes" />
		<cfargument name="gateway" type="any" required="yes" />

		<cfset variables.object = arguments.object />		
		<cfset variables.gateway = arguments.gateway />	
	</cffunction>
	
	<cffunction name="getCurrentUsersList" access="public" returntype="supermodel.objectlist">
		<cfset var query = variables.gateway.select() />
		<cfset var list = createObject('component', 'supermodel.objectlist') />

		<cfset list.init(
			variables.object,
			query) />
	
		<cfreturn list />
	</cffunction>
	
	<cffunction name="getUsersByRole" access="public" returntype="supermodel.objectlist">
		<cfargument name="role" type="string" required="yes" />	
		<cfset var list = createObject('component', 'supermodel.objectlist') />
		<cfset var query = variables.gateway.selectByRole(arguments.role) />

		<cfset list.init(
			variables.object,
			query) />

		<cfreturn list />
	</cffunction>
	
	<cffunction name="getPotentialUsersList" access="remote" returntype="supermodel.objectlist" output="true"> 
		<cfset var query = '' />
		<cfset var list = createObject('component', 'supermodel.objectlist')  />
		<cfset query = variables.gateway.usersNotInApplication(application_name=application.applicationname) />

		<cfset list.init(
			variables.object,
			query) />
	
		<cfreturn list />
	</cffunction>
	
	<cffunction name="getUser" access="public">
		<cfreturn variables.object />
	</cffunction>
</cfcomponent>