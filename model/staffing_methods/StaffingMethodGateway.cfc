<cfcomponent extends="supermodel.gateway">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.table_name = 'staffing_methods' />
		<cfset variables.cache = true />
	</cffunction>
</cfcomponent>