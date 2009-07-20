<cfcomponent extends="supermodel.datamodel">
	<cffunction name="configure">
		<cfset variables.table_name = 'staffing_activities' />
		<cfset belongsTo('phase', 'hr_staffing.model.phases.phase') />
	</cffunction>
</cfcomponent>