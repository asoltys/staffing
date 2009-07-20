<cfcomponent>	

<!--------------------------------------------------------------------------------------------- init

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="init" access="public" returntype="void">
		<cfargument name="object" type="any" required="yes" />
		<cfargument name="gateway" type="any" required="yes" />
		
		<cfset variables.object = arguments.object />
		<cfset variables.gateway = arguments.gateway />
	</cffunction>
	
<!-------------------------------------------------------------------------------------------- getList

	Description:	
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getList" access="public" returntype="supermodel.objectlist">		
		<cfset var list = createObject('component', 'supermodel.objectlist') />
		<cfset var query = variables.gateway.select() />
		
		<cfset list.init(
			variables.object,
			query) />
	
		<cfreturn list />
	</cffunction>
		
</cfcomponent>
