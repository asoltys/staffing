<cfcomponent extends="supermodel.Gateway">
	<cffunction name="configure">
		<cfset variables.table_name = 'security_levels' />
		<cfset variables.cache = true />
	</cffunction>
</cfcomponent>