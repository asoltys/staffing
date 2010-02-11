<cfset location = event.getArg('location') />
<cfset regions = event.getArg('regions') />
<cfset errors = event.getArg('errors') />

<cfinclude template="#request.includes_path#includes/helpers.cfm">

<cfoutput>

<cfif location.persisted()>
  <h1>Edit Location</h1>
<cfelse>
  <h1>Add Location</h1>
</cfif>

<cfinvoke method="displayErrors" />

<form action="#request.path#index.cfm?event=locations.process" method="post">
	<fieldset>
		<legend>Add Form</legend>
		<label for="name">Name</label>
		<input type="text" name="name" id="name" value="#location.name#" />
		<br /><br />
		
		<label for="region_id">Region</label>
		<select name="region_id" id="region_id">
			<option value="">Select One</option>
			<cfloop condition="#regions.next()#">
				<cfset region = regions.current() />
				<cfif location.region.id eq region.id>
					<cfset selected = 'selected = "selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#region.id#" #selected#>#region.name#</option>
			</cfloop>
		</select>
		<br /><br />

		<input type="hidden" name="id" id="id" value="#location.id#" />
		<input type="submit" name="submit_button" id="submit_button" class="submitButton" value="Submit" />
	</fieldset>
</form>

</cfoutput>

