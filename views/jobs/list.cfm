<cfset branches = event.getArg('branches') />
<cfset classification_levels = event.getArg('classification_levels') />
<cfset jobs = event.getArg('jobs') />

<cfset errors = event.getArg('errors') />
<cfset row_num = 1 />

<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfoutput>

<h1>Jobs</h1>

<cfinvoke method="displayErrors" />

<form class="noPrint" action="#request.path#index.cfm?event=jobs.list" method="post">
	<fieldset>
		<input id="user_id" name="user_id" type="hidden" value="#event.getArg('user_id')#" />
		<span class="dropdown">
			<label for="group_level">Group / Level</label>
			<select name="classification_level_id">
			<option value="">All</option>
				<cfloop condition="#classification_levels.next()#">
					<cfset classification_level = classification_levels.current() />
					<cfif classification_level.id eq event.getArg('classification_level_id')>
						<cfset selected = 'selected="selected"' />
					<cfelse>
						<cfset selected = '' />
					</cfif>
					<option value="#classification_level.id#" #selected#>#classification_level.classification.name#-#classification_level.name#</option>
				</cfloop>
			</select>
		</span>
		<span class="dropdown">
			<label for="branch">Branch</label>
			<select name="branch">
			<option value="">All</option>
				<cfloop condition="#branches.next()#">
					<cfset branch = branches.current() />
					<cfif branch.acronym eq event.getArg('branch')>
						<cfset selected = 'selected="selected"' />
					<cfelse>
						<cfset selected = '' />
					</cfif>
					<option value="#branch.acronym#" #selected#>#branch.name#</option>
				</cfloop>
			</select>
		</span>
		<input name="search" type="submit" value="Search" class="submitButton"/>
	</fieldset>
</form>
<p>
	<a class="addLink" href="#request.path#index.cfm?event=jobs.form">Add Job</a>
</p>
<cfif jobs.length() GT 0>

<table class="list">
	<tr>
		<th>Group / Level</th>
		<th>Title</th>
		<th>Branch</th>
		<th class="icon">&nbsp;</th>
	</tr>
	<cfloop condition="#jobs.next()#">
		<cfinvoke component="#request.parent_path#includes/helpers"
				 method="altRow"
				 row_num="#row_num#"
				 returnvariable="altClass" />
		<cfset job = jobs.current() />
		<tr class="#altClass#">
			<td>#job.groupAndLevel()#</td>
			<td><a href="#request.path#index.cfm?event=jobs.form&amp;id=#job.id#">#job.title#</a></td>
			<td>#job.branch#</td>
			<td class="delete icon"><a href="#request.path#index.cfm?event=jobs.delete&amp;id=#job.id#" class="deleteLink" title="Delete Job"/><span>Delete Job</span></a></td>
		</tr>
		<cfset row_num = row_num + 1 />
	</cfloop>
</table>
<cfelse>
	<p class="warning">No jobs were found</p>
</cfif>
<p>
	<a class="addLink" href="#request.path#index.cfm?event=jobs.form">Add Job</a>
</p>
</cfoutput>