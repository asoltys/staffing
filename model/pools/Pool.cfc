<cfcomponent extends="supermodel.DataModel">
	<cffunction name="configure">
		<cfset variables.table_name = 'pools' />
		<cfset belongsTo('process', 'hr_staffing.model.processes.Process') />
		<cfset belongsTo('contact', 'hr_staffing.model.users.User') />
		<cfset belongsTo('classification_level', 'hr_staffing.model.classification_levels.ClassificationLevel') />
	</cffunction>
</cfcomponent>