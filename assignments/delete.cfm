<cfquery datasource="#request.dsn#">
  delete from assignments where id = 
    <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer" />
</cfquery>
