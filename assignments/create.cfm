<cfquery datasource="#request.dsn#">
  insert into assignments (process_id, expiry_date, comments)
  values (
    <cfqueryparam value="#form.process_id#" cfsqltype="cf_sql_integer" />,
    <cfqueryparam value="#form.expiry_date#" cfsqltype="cf_sql_date" />,
    <cfqueryparam value="#form.comments#" cfsqltype="cf_sql_varchar" />
  )
</cfquery>
