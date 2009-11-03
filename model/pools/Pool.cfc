<cfcomponent extends="supermodel.DataModel">
	<cffunction name="configure">
		<cfset variables.table_name = 'pools' />
		<cfset belongsTo('process', 'hr_staffing.model.processes.process') />
		<cfset belongsTo('contact', 'hr_staffing.model.users.user') />
		<cfset belongsTo('classification_level', 'hr_staffing.model.classification_levels.ClassificationLevel') />
	</cffunction>
</cfcomponent>