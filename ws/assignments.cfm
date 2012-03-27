<cfquery name="query" datasource="#request.dsn#">
  SELECT 
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
    "process_id": "#query.process_id#",
    "expiry_date": "#query.expiry_date#",
    "comments": "#query.comments#",
    "number": "#query.number#",
    "title": "#query.title#"
    }<cfif query.currentrow neq query.recordcount>,</cfif>
  </cfloop>
]
</cfoutput>
