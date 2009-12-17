<cfcomponent>
	<cffunction name="init" access="public" returntype="void" output="false">
		<cfargument name="object" type="any" required="yes" />
		<cfargument name="gateway" type="any" required="yes" />

		<cfset variables.object = arguments.object />		
		<cfset variables.gateway = arguments.gateway />	
	</cffunction>
	
	<cffunction name="getRoleList" access="public" returntype="supermodel.ObjectList">
		<cfset var query = variables.gateway.select() />
		<cfset var list = createObject('component', 'supermodel.ObjectList') />
		
		<cfset list.init(
			variables.object,
			query) />
	
		<cfreturn list />
	</cffunction>
</cfcomponent>