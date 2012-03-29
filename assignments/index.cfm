<cfoutput>

<cfsavecontent variable="head">
  <script src="json2.js"></script>
  <script src="underscore-1.3.1.js"></script>
  <script src="backbone.js"></script>
  <script src="handlebars.js"></script>
  <script src="assignment.js"></script>
  <script src="form.js"></script>
  <script src="assignments.js"></script>
</cfsavecontent>
<cfhtmlhead text="#head#" />

<h1>Assignments</h1>

<table id="assignments">
  <thead>
    <tr>
      <th>Process</th>
      <th>Job</th>
      <th>Expiry Date</th>
      <th>Delete</th>
    </tr>
  </thead>
</table>

</cfoutput>
