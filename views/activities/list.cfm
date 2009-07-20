<cfset activities = event.getArg('activities') />

<cfoutput>

<h1>Activity List</h1>

<table>
	<tr>
		<th>&nbsp;</th>
		<th>Name</th>
	</tr>
	<cfloop query="activities">
	<tr>
		<td><a href="index.cfm?event=showActivityForm&id=#activities.id#">Edit</a></td>
		<td>#activities.name#</td>
	</tr>
	</cfloop>
</table>

<p>
	<a href="index.cfm?event=showActivityForm">Add Activity</a>
</p>

</cfoutput>