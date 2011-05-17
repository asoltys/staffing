<cfcomponent extends="supermodel.DataModel">
	<cffunction name="configure">
		<cfset variables.table_name = 'pools' />
		<cfset belongsTo('process', 'hr_staffing.model.processes.Process') />
		<cfset belongsTo('contact', 'hr_staffing.model.users.User') />
		<cfset belongsTo('classification_level', 'hr_staffing.model.classification_levels.ClassificationLevel') />

    <cfset addProperty('id', 'integer') />
    <cfset addProperty('process_id', 'integer') />
    <cfset addProperty('contact_id', 'integer') />
    <cfset addProperty('classification_level_id', 'integer') />
    <cfset addProperty('creation_date', 'datetime') />
    <cfset addProperty('expiry_date', 'datetime') />
    <cfset addProperty('description', 'text') />
    <cfset addProperty('title', 'varchar') />
    <cfset addProperty('language', 'varchar') />
	</cffunction>
</cfcomponent>
