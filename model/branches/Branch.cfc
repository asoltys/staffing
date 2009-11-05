<cfcomponent extends="hr_staffing.modules.common_login.model.Branch">	
	<cffunction name="getManagers" access="public" returntype="supermodel.ObjectList">
		<cfargument name="query" type="query" required="yes">

		<cfset var object = createObject('component', 'hr_staffing.model.users.Manager') />
		<cfset var list = createObject('component', 'supermodel.ObjectList') />
		
		<cfset object.init(variables.dsn) />
		
		
		<cfset list.init(
			object,
			query) />
		
		<cfreturn list />
	</cffunction>
</cfcomponent>