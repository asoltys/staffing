<cfcomponent>
	<cffunction name="init" access="public" returntype="void" output="false">
		<cfargument name="object" type="any" required="yes" />
		<cfargument name="gateway" type="any" required="yes" />
		
		<cfset variables.region = arguments.object />
		<cfset variables.regionGateway = arguments.gateway />
	</cffunction>
	
	<cffunction name="getList" access="remote" returntype="supermodel.ObjectList"> 			
		<cfset var query = variables.regionGateway.select() />
		<cfset var list = createObject('component','supermodel.ObjectList') />

		<cfset list.init(variables.region,query) />
	
		<cfreturn list />
	</cffunction>
</cfcomponent>

