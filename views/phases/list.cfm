<cfset phases = event.getArg('phases') />

<cfoutput>

<h1>Phase List</h1>

<table>
	<tr>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>Name</th>
	</tr>
	<cfloop query="phases">
	<tr>
		<td><a href="index.cfm?event=showPhaseForm&id=#phases.id#">Edit</a></td>
		<td><a href="index.cfm?event=removePhase&id=#phases.id#">Remove</a></td>
		<td>#phases.name#</td>
	</tr>
	</cfloop>
</table>

<p>
	<a href="index.cfm?event=showPhaseForm">Add Phase</a>
</p>

</cfoutput>