<cfset staffers = event.getArg('staffers') />

<cfoutput>

<h1>Manage Users</h1>

<br />

<form id="assignment_form" action="#request.path#index.cfm?event=positions.processAssignments" method="post">
	<input id="positions" name="positions" type="hidden" value="#url.positions#" />
	
	<label for="action">Action</label>
	<select id="action" name="action">
		<option value="assign">Assign</option>
		<option value="unassign">Unassign</option>
	</select>
	
	<label for="users">Staff Members <small>(CTRL-Click to Select Multiple Users)</small></label>
	<select id="users" name="users" multiple="multiple">
		<cfloop condition="#staffers.next()#">
			<cfset staffer = staffers.current() />
			<option value="#staffer.id#">#staffer.getName()#</option>
		</cfloop>
	</select>
</form>

</cfoutput>
