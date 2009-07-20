<cfcomponent extends="supermodel.datamodel">
	<cffunction name="configure" access="public" returntype="void" >
		<cfset variables.table_name = 'classification_levels' />
		<cfset belongsTo('classification', 'hr_staffing.model.classifications.classification') />
	</cffunction>
</cfcomponent>