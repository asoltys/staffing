<cfset request.current_user = request.current_user />
<cfset position = event.getArg('position') />
<cfset process = event.getArg('process') />
<cfset processes = event.getArg('processes') />
<cfset board_chairs = event.getArg('board_chairs') />
<cfset staffing_methods = event.getArg('staffing_methods') />
<cfset errors = event.getArg('errors') />

<cfinclude template="#request.includes_path#includes/helpers.cfm">

<cfoutput>

<cfinvoke method="displayErrors" />

<h1>Specify Position's Process Details</h1>

<cfinvoke method="position_details" position="#position#" />

<h2>Existing Process</h2>
	
<form action="index.cfm?event=positions.update_process" method="post">	
	<input id="id" name="id" value="#position.id#" type="hidden">
	
	<label for="process_id">Process Number:</label>
	<select id="process_id" name="process_id">
		<option value="">Select One</option>
		<cfloop condition="#processes.next()#">
			<cfset current_process = processes.current() />
			
			<cfset selected = "" />
			<cfif current_process.id EQ position.process_id>
				<cfset selected = "selected=""selected""" />
			</cfif>

			<option value="#current_process.id#" #selected#>#current_process.number#</option>
		</cfloop>
	</select>

	<input type="submit" name="submit_button" id="submit_button" value="Select" class="submitButton"/>
</form>

<h2>New Process</h2>
	
<form action="index.cfm?event=positions.create_process" method="post">
	<input id="position_id" name="position_id" type="hidden" value="#position.id#" />
	<input id="process_id" name="process_id" type="hidden" value="#process.id#" />
		
	<label for="number">Process Number</label>
	<input id="number" name="number" type="text" value="#process.number#" />
	
	<br />
	
	<label for="board_chair_id">Board Chair:</label>
	<select id="board_chair_id" name="board_chair_id">
		<option value="">Select One</option>
		<cfloop condition="#board_chairs.next()#">
			<cfset board_chair = board_chairs.current() />
			<option value="#board_chair.id#">#board_chair.getName()#</option>
		</cfloop>
	</select>
	
	<br />

	<label for="staffing_method_id">Staffing Method:</label>
	<select id="staffing_method_id" name="staffing_method_id">
		<option value="">Select One</option>
		<cfloop condition="#staffing_methods.next()#">		
			<cfset staffing_method = staffing_methods.current() />
			<option value="#staffing_method.id#">#staffing_method.name#</option>
		</cfloop>
	</select>

	<input type="submit" name="submit_button" id="submit_button" value="Create" class="submitButton"/>
</form>

</cfoutput>