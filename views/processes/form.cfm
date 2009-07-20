<cfset process = event.getArg('process') />
<cfset board_chairs = event.getArg('board_chairs') />
<cfset staffing_methods = event.getArg('staffing_methods') />
<cfset errors = event.getArg('errors') />

<cfinclude template="#request.includes_path#includes/helpers.cfm">

<cfoutput>

<h1>Process</h1>

<cfinvoke method="displayErrors" />

<form class="process" action="index.cfm?event=processes.process" method="post">
	<input id="id" name="id" type="hidden" value="#process.id#" />

	<label for="number">Process Number:</label>
	<br />
	<input id="number" name="number" type="text" value="#process.number#" />

	<br />

	<label for="board_chair_id">Board Chair:</label>
	<br />
	<select id="board_chair_id" name="board_chair_id">
		<option value="">Select One</option>
		<cfloop condition="#board_chairs.next()#">
			<cfset board_chair = board_chairs.current() />

			<cfset selected = "" />
			<cfif board_chair.id EQ process.board_chair_id>
				<cfset selected = "selected=""selected""" />
			</cfif>

			<option value="#board_chair.id#" #selected#>#board_chair.getName()#</option>
		</cfloop>
	</select>

	<br />

	<label for="staffing_method_id">Staffing Method:</label>
	<br />
	<select class="staffingMethod" id="staffing_method_id" name="staffing_method_id">
		<option value="">Select One</option>
		<cfloop condition="#staffing_methods.next()#">
			<cfset staffing_method = staffing_methods.current() />

			<cfset selected = "" />
			<cfif staffing_method.id EQ process.staffing_method_id>
				<cfset selected = "selected=""selected""" />
			</cfif>

			<option value="#staffing_method.id#" #selected#>#staffing_method.name#</option>
		</cfloop>
	</select>

	<br />

	<label for="collective">Collective Process:</label>

	<cfset checked = "" />

	<cfif process.isCollectiveProcess()>
		<cfset checked = "checked=""checked""" />
	</cfif>
	<input id="collective" name="collective" type="checkbox" #checked# value="1" class="checkbox"/>

	<br />

	<label for="cancelation_date">Cancelation Date:</label>
	<br />
	<input id="cancelation_date" name="cancelation_date" type="text" value="#LSDateFormat(process.cancelation_date, "yyyy-mm-dd")#" class="date" />
	<img src="#request.path#images/calendar.gif" class="calendar" />
	<br />
	<input type="submit" name="submit_button" id="submit_button" value="Save" class="submitButton"/>
</form>

</cfoutput>