<cfoutput>
<cfsavecontent variable="head">
  <script src="assignments.js"></script>
</cfsavecontent>

<cfhtmlhead text="#head#" />

<cfquery name="processes" datasource="#request.dsn#">
  SELECT * FROM processes
  JOIN staffing_methods
  ON processes.staffing_method_id = staffing_methods.id
  WHERE staffing_methods.name LIKE '%Acting%'
  ORDER BY number DESC
</cfquery>

<cfquery name="assignments" datasource="#request.dsn#">
  SELECT 
    processes.number,
    assignments.expiry_date,
    assignments.comments
  FROM assignments 
  JOIN processes
  ON processes.id = assignments.process_id
</cfquery>

<h1>Assignments</h1>

<cfif request.current_user.hasRole('HR Staff')>
  <form id="create">
    <label for="process_id">Process</label>
    <select id="process_id" name="process_id">
      <cfloop query="processes">
        <option value="#processes.id#">#processes.number#</option>
      </cfloop>
    </select>

    <label for="expiry_date">Expiry Date</label>
    <input id="expiry_date" name="expiry_date" class="datepicker" type="text" />

    <label for="comments">Comments</label>
    <textarea id="comments" name="comments"></textarea>

    <input type="submit" value="Add New Assignment" />
  </form>
</cfif>

<h2>Acting Assignments</h2>

<table id="actings">
  <thead>
    <tr>
      <th>Process</th>
      <th>Expiry Date</th>
    </tr>
  </thead>
  <tbody>
    <cfloop query="assignments">
      <tr>
        <td>#assignments.number#</td>
        <td>#assignments.expiry_date#</td>
      </tr>
    </cfloop>
  </tbody>
</table>

<h2>Terms</h2>

<table>
  <thead>
    <tr>
      <th>Process</th>
      <th>Expiry Date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
</cfoutput>
