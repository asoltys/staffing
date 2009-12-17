<cfcomponent>
	<cffunction name="init" access="public" returntype="void" output="false">
		<cfargument name="object" type="any" required="yes" />
		<cfargument name="gateway" type="any" required="yes" />
		
		<cfset variables.branch = arguments.object />
		<cfset variables.branchGateway = arguments.gateway />
	</cffunction>
	
	<cffunction name="getList" access="remote" returntype="supermodel.ObjectList"> 			
		<cfset var query = variables.branchGateway.select() />
		<cfset var list = createObject('component','supermodel.ObjectList') />

		<cfset list.init(variables.branch,query) />
	
		<cfreturn list />
	</cffunction>
</cfcomponent>