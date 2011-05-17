<cfoutput>
	<table class="list">
		<tr>
			<th>Process</th>
			<th>Job</th>
			<th>Contact</th>
			<th>Created</th>
			<th>Expires</th>
			<cfif request.current_user.hasRole('HR Staff')>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			</cfif>
		</tr>
		<cfloop condition="#pools.next()#">
			<cfset pool = pools.current() />
			<cfinvoke component="#request.parent_path#/includes/helpers" method="altRow" returnvariable="row_class" />
			<tr class="#row_class#" style="vertical-align: top;">
				<td>
          <a href="#request.path#index.cfm?event=processes.ssda&amp;process_id=#pool.process.id#">
            #pool.process.number#
          </a>
          <br />
          #pool.classification_level.classification.name#-#pool.classification_level.name# 
        </td>
				<td>
          <strong>#pool.title#</strong><br />
          ( #pool.language# )
        </td>
				<td><a href="mailto:#pool.contact.email#">#pool.contact.getName()#</a></td>
        <td>#DateFormat(pool.creation_date, "yyyy-mm-dd")#</td>
        <td>#DateFormat(pool.expiry_date, "yyyy-mm-dd")#</td>
				<cfif request.current_user.hasRole('HR Staff')>
				<td><a href="#request.path#index.cfm?event=pools.form&amp;id=#pool.id#">Edit</a></td>
				<td><a href="#request.path#index.cfm?event=pools.delete&amp;pool_id=#pool.id#" class="deleteLink" title="Delete">Delete</a></td>
				</cfif>
			</tr>
			<tr class="#row_class#">
				<td colspan="7">
					#pool.description#
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
