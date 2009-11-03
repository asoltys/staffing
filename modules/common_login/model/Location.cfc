<cfcomponent displayname="Location" extends="supermodel.DataModel">
	<cffunction name="configure" access="public" returntype="void">
		<cfset variables.object_path = 'common_login.model.locations.location' />
		<cfset variables.table_name = 'locations' />
	</cffunction>
</cfcomponent>