<cfcomponent extends="supermodel.DataModel">
	<cffunction name="configure" access="public" returntype="void" >
		<cfset variables.table_name = 'classification_levels' />
		<cfset belongsTo('classification', 'hr_staffing.model.classifications.Classification') />
	</cffunction>
</cfcomponent>