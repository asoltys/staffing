<cfset activity = event.getArg('activity') />
<cfset phases = event.getArg('phases') />

<cfoutput>

<h1>Activity Form</h1>

<form name="ActivityForm" action="index.cfm?event=activities.process" method="post">
	<input id="id" name="id" type="hidden" value="#activity.id#" />
		
	<label for="name">Name</label>
	<input id="name" name="name" type="text" value="#activity.name#" />
	
	<br />
	
	<label for="phase_id">Phase</label>
	<select id="phase_id" name="phase_id">
		<option value="">Select One</option>
		<cfloop condition="#phases.next()#">
			<cfset phase = phases.current() />
			
			<cfset selected = "" />
			<cfif phase.id EQ activity.phase_id>
				<cfset selected = "selected=""selected""" />
			</cfif>
				
			<option value="#phase.id#" #selected#>#phase.name#</option>
		</cfloop>
	</select>
	
	<label for="default_endangered_time">Default At Risk Time (days)</label>
	<input id="default_endangered_time" name="default_endangered_time" type="text" value="#activity.default_endangered_time#" />
	
	<br />
	
	<label for="sequence">Sequence Number</label>
	<input id="sequence" name="sequence" type="text" value="#activity.sequence#" />
	
	<br />
	
	<input type="submit" name="submit_button" id="submit_button" value="Submit" />
</form>

</cfoutput>