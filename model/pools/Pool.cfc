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

  <cffunction name="getMailingList" access="public">
    <cfset var contacts = "" />

    <cfquery name="contacts" datasource="#request.dsn#">
      SELECT cl.email
      FROM common_login..users cl
      JOIN staffing_users ON staffing_users.login = cl.login
      JOIN positions_users ON positions_users.user_id = staffing_users.id
      JOIN positions ON positions.id = positions_users.position_id
      WHERE positions.process_id = 
        <cfqueryparam value="#this.process_id#" cfsqltype="cf_sql_integer" />
    </cfquery>

    <cfreturn "#this.contact.email#;#valueList(contacts.email, ';')#" />
  </cffunction>
</cfcomponent>
