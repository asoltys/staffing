<cfcomponent extends="supermodel.DataModel">	
	<cffunction name="configure">
		<cfset variables.table_name = 'staffing_comments' />
		<cfset belongsTo('user', 'hr_staffing.model.users.User') />
	</cffunction>
</cfcomponent>