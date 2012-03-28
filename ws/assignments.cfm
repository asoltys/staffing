<cfquery name="query" datasource="#request.dsn#">
  SELECT 
    assignments.id,
    assignments.process_id,
    assignments.expiry_date,
    assignments.comments,
    processes.number,
    jobs.title
  FROM assignments 
  JOIN processes
    ON processes.id = assignments.process_id
  JOIN positions 
    ON positions.process_id = processes.id
  JOIN jobs 
    ON positions.job_id = jobs.id
  ORDER BY expiry_date
</cfquery>

<cfoutput>
[
  <cfloop query="query">
  {
    "id": "#query.id#",
    "process_id": "#query.process_id#",
    "expiry_date": "#dateFormat(query.expiry_date, 'yyyy-mm-dd')#",
    "comments": "#query.comments#",
    "number": "#query.number#",
    "title": "#query.title#"
    }<cfif query.currentrow neq query.recordcount>,</cfif>
  </cfloop>
]
</cfoutput>
