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
	
<!---------------------------------------------------------------------------------------- getJobList

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="getList" access="public" returntype="supermodel.ObjectList">
		<cfargument name="parameters" type="struct" />
		<cfset var query = '' />
		<cfset var list = createObject('component', 'supermodel.ObjectList') />

		<cfif structKeyExists(arguments, 'parameters')>
			<cfset query = variables.gateway.select(arguments.parameters.classification_level_id,
				arguments.parameters.branch,
				arguments.parameters.location,
				arguments.parameters.role) />
		<cfelse>
			<cfset query = variables.gateway.select() />
		</cfif>		
		
		<cfset list.init(
			variables.object,
			query) />
	
		<cfreturn list />
	</cffunction>
	
<!------------------------------------------------------------------------------ getExistingJobTitles

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="getExistingJobTitles" access="public" returntype="query">
		<cfreturn variables.gateway.selectExistingJobTitles() />
	</cffunction>
</cfcomponent>
