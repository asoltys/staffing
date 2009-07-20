<cfset processes = event.getArg('processes') />
<cfset errors = event.getArg('errors') />
<cfset row_num = 1 />

<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfoutput>

<h1>Processes</h1>

<cfinvoke method="displayErrors" />

<p>
	<a class="addLink" href="#request.path#index.cfm?event=processes.form">Add Process</a>
</p>
<cfif processes.length() GT 0>

<table class="list">
	<tr>
		<th>Number</th>
		<th>Board Chair</th>
		<th class="icon">&nbsp;</th>
	</tr>
	<cfloop condition="#processes.next()#">
		<cfinvoke component="#request.parent_path#includes/helpers"
				 method="altRow"
				 row_num="#row_num#"
				 returnvariable="altClass" />
		<cfset process = processes.current() />
		<tr class="#altClass#">
			<td><a href="#request.path#index.cfm?event=processes.form&amp;id=#process.id#">#process.number#</a></td>
			<td>#process.board_chair.getName()#</td>
			<td class="delete icon"><a href="#request.path#index.cfm?event=processes.delete&amp;process_id=#process.id#" class="deleteLink" title="Delete"/><span>Delete</span></a></td>
		</tr>
		<cfset row_num = row_num + 1 />
	</cfloop>
</table>
<cfelse>
	<p>No stand-alone processes were found</p>
</cfif>
<p>
	<a class="addLink" href="#request.path#index.cfm?event=processes.form">Add Process</a>
</p>
</cfoutput>