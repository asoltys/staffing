<cfset locations = event.getArg('locations') />

<cfset errors = event.getArg('errors') />
<cfset row_num = 1 />

<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfoutput>

<h1>Locations</h1>

<cfinvoke method="displayErrors" />

<p>
	<a class="addLink" href="#request.path#index.cfm?event=locations.form">Add location</a>
</p>
<cfif locations.length() GT 0>

<table class="list">
	<tr>
		<th>Name</th>
		<th>Region</th>
		<th class="icon">&nbsp;</th>
	</tr>
	<cfloop condition="#locations.next()#">
		<cfinvoke component="#request.parent_path#includes/helpers"
				 method="altRow"
				 row_num="#row_num#"
				 returnvariable="altClass" />
		<cfset location = locations.current() />
		<tr class="#altClass#">
			<td><a href="#request.path#index.cfm?event=locations.form&amp;id=#location.id#">#location.name#</a></td>
			<td>#location.region#</td>
			<td class="delete icon"><a href="#request.path#index.cfm?event=locations.delete&amp;id=#location.id#" class="deleteLink" title="Delete location"/><span>Delete location</span></a></td>
		</tr>
		<cfset row_num = row_num + 1 />
	</cfloop>
</table>
<cfelse>
	<p class="warning">No locations were found</p>
</cfif>
<p>
	<a class="addLink" href="#request.path#index.cfm?event=locations.form">Add location</a>
</p>
</cfoutput>

