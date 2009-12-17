<cfcomponent extends="supermodel.Gateway">
	<cffunction name="configure">
		<cfset variables.table_name = 'tenures' />
		<cfset variables.cache = true />
	</cffunction>
</cfcomponent>