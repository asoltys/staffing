<cfcomponent extends="cms.model.users.User">
	<cffunction name="configure" access="private" returntype="void">
		<cfset super.configure() />
		<cfset variables.table_name = "staffing_users" />
		<cfset variables.application_name = "HR Staffing" />
	</cffunction>
</cfcomponent>
