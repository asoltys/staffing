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

<!---
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
--->

  <script type="text/template" id="assignments-template">
    
  </script>
</cfoutput>
