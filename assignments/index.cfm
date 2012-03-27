<cfoutput>
<cfsavecontent variable="head">
  <script src="json2.js"></script>
  <script src="underscore-1.3.1.js"></script>
  <script src="backbone.js"></script>
  <script src="handlebars.js"></script>
  <script src="process.template.js"></script>
  <script src="assignments.js"></script>
</cfsavecontent>

<cfhtmlhead text="#head#" />

<cfquery name="processes" datasource="#request.dsn#">
  SELECT 
    processes.id, 
    processes.number
  FROM processes
  JOIN staffing_methods
    ON processes.staffing_method_id = staffing_methods.id
  WHERE staffing_methods.name LIKE '%Acting%'
  ORDER BY number DESC
</cfquery>

<cfquery name="assignments" datasource="#request.dsn#">
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

<h1>Assignments</h1>


  <table id="assignments">
    <thead>
      <tr>
        <th>Process</th>
        <th>Job</th>
        <th>Expiry Date</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
    </tbody>
  </table>

<cfif request.current_user.hasRole('HR Staff')>
  <form id="create">
    <label for="process_id">Process</label>
    <select id="process_id" name="process_id">
    </select>

    <label for="expiry_date">Expiry Date</label>
    <input id="expiry_date" name="expiry_date" class="datepicker" type="text" />

    <label for="comments">Comments</label>
    <textarea id="comments" name="comments"></textarea>

    <input type="submit" value="Submit" />
  </form>
</cfif>

  <script type="text/template" id="process-template">
    {{#each processess}}
      <option value="{{id}}">{{number}}</option>
    {{\each}}
  </script>
item</cfoutput>
