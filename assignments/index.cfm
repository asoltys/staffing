<cfoutput>

<cfsavecontent variable="head">
  <script src="json2.js"></script>
  <script src="underscore-1.3.1.js"></script>
  <script src="backbone.js"></script>
  <script src="handlebars.js"></script>
  <script src="assignments.template.js"></script>
  <script src="process.template.js"></script>
  <script src="assignments.js"></script>
</cfsavecontent>
<cfhtmlhead text="#head#" />

<h1>Assignments</h1>

<div id="assignments-container"></div>

</cfoutput>
