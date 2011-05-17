<cfcomponent extends="supermodel.DataModel">
	<cffunction name="configure">
		<cfset variables.table_name = 'pools' />
		<cfset belongsTo('process', 'hr_staffing.model.processes.Process') />
		<cfset belongsTo('contact', 'hr_staffing.model.users.User') />

    <cfset addProperty('id', 'integer') />
    <cfset addProperty('process_id', 'integer') />
    <cfset addProperty('contact_id', 'integer') />
    <cfset addProperty('creation_date', 'datetime') />
    <cfset addProperty('expiry_date', 'datetime') />
    <cfset addProperty('description', 'text') />

    <cfset this.creation_date = "" />
    <cfset this.title = "" />
    <cfset this.language = "" />
    <cfset this.classification_name = "" />
    <cfset this.classification_level_name = "" />
	</cffunction>

  <cffunction name="insertQuery">
    <cfset this.creation_date = now() />
    <cfset super.insertQuery() />
  </cffunction>
</cfcomponent>
