<cfcomponent extends="supermodel.Gateway">
	<cffunction name="configure">
		<cfset variables.table_name = 'statuses' />
		<cfset variables.cache = true />
	</cffunction>
</cfcomponent>