<cfquery name="processes" datasource="#request.dsn#">
  SELECT 
    processes.number,
    assignments.expiry_date,
    assignments.comments
  FROM assignments 
  JOIN processes
  ON processes.id = assignments.process_id
</cfquery>

<cfinvoke 
  component="hr_staffing.helpers.json" 
  method="encode" 
  data="#processes#" 
  returnvariable="json" />

<cfoutput>#json#</cfoutput>
