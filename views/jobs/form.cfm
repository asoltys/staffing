<cfset job = event.getArg('job') />
<cfset classifications = event.getArg('classifications') />
<cfset classification_levels = event.getArg('classification_levels') />
<cfset branches = event.getArg('branches') />
<cfset errors = event.getArg('errors') />

<cfinclude template="#request.includes_path#includes/helpers.cfm">

<cfoutput>

<cfif job.persisted()>
<h1>Edit Job</h1>
<cfelse>
<h1>Add Job</h1>
</cfif>

<cfinvoke method="displayErrors" />

<form action="#request.path#index.cfm?event=jobs.process" method="post">
	<fieldset>
		<legend>Add Form</legend>
		<label for="title">Title</label>
		<input type="text" name="title" id="title" value="#job.title#" />
		<br /><br />
		
		<label for="classificataion_level_id">Group / Level</label>
		<select name="classification_level_id" id="classification_level_id">
			<option value="">Select One</option>
			<cfloop condition="#classifications.next()#">
				<cfset classification = classifications.current() />
				<optgroup label="#classification.name#">
				<cfset classification_levels.reset() />
				<cfloop condition="#classification_levels.next()#">
					<cfset level = classification_levels.current() />
					<cfif level.classification_id eq classification.id>
						<cfif job.classification_level_id eq level.id>
							<cfset selected = 'selected = "selected"' />
						<cfelse>
							<cfset selected = '' />
						</cfif>
						<option value="#level.id#" #selected#>#classification.name# - #level.name#</option>
					</cfif>
				</cfloop>
				</optgroup>
			</cfloop>
		</select>
		<br /><br />
		<input type="hidden" name="classification_id" id="classification_id" value="#job.classification_id#" />
		<label for="branch">Branch</label>
		<select name="branch" id="branch">
			<option value="">Select One</option>
			<cfloop condition="#branches.next()#">
				<cfset branch = branches.current() />
				<cfif job.branch eq branch.acronym>
					<cfset selected = 'selected = "selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#branch.acronym#" #selected#>#branch.name#</option>
			</cfloop>
		</select>
		<br /><br />
		
		<input type="hidden" name="display" id="display" value="#job.display#" />
		<input type="hidden" name="draft" id="draft" value="#job.draft#" />
		<input type="hidden" name="id" id="id" value="#job.id#" />
		<input type="submit" name="submit_button" id="submit_button" class="submitButton" value="Submit" />
	</fieldset>
</form>

</cfoutput>
