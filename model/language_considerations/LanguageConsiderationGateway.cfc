<cfcomponent extends="supermodel.Gateway">
	<cffunction name="configure" access="public" returntype="void" >
		<cfset variables.table_name = 'language_considerations' />
		<cfset variables.cache = true />
	</cffunction>
</cfcomponent>