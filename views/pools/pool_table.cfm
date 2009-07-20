<cfoutput>
	<table class="list">
		<tr>
			<th>Process</th>
			<th>Group / Level</th>
			<th>Contact</th>
			<th>Expiry Date</th>
			<cfif request.current_user.hasRole('HR Staff')>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			</cfif>
		</tr>
		<cfloop condition="#pools.next()#">
			<cfset pool = pools.current() />
			<cfinvoke component="#request.parent_path#/includes/helpers" method="altRow" returnvariable="row_class" />
			<tr class="#row_class#">
				<td><a href="#request.path#index.cfm?event=processes.ssda&amp;process_id=#pool.process.id#">#pool.process.number#</a></td>
				<td>#pool.classification_level.classification.name#-#pool.classification_level.name#</td>
				<td><a href="mailto:#pool.contact.email#">#pool.contact.getName()#</a></td>
        <td>#DateFormat(pool.expiry_date, "yyyy-mm-dd")#</td>
				<cfif request.current_user.hasRole('HR Staff')>
				<td><a href="#request.path#index.cfm?event=pools.form&amp;id=#pool.id#">Edit</a></td>
				<td><a href="#request.path#index.cfm?event=pools.delete&amp;pool_id=#pool.id#" class="deleteLink" title="Delete">Delete</a></td>
				</cfif>
			</tr>
			<tr class="#row_class#">
				<td>Description:</td>
				<td colspan="6">
					#pool.description#
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
