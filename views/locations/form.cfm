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
		
		<label for="region">Region</label>
		<select name="region" id="region">
			<option value="">Select One</option>
			<cfloop condition="#regions.next()#">
				<cfset region = regions.current() />
				<cfif location.region eq region.acronym>
					<cfset selected = 'selected = "selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#region.acronym#" #selected#>#region.name#</option>
			</cfloop>
		</select>
		<br /><br />

		<input type="hidden" name="id" id="id" value="#location.id#" />
		<input type="submit" name="submit_button" id="submit_button" class="submitButton" value="Submit" />
	</fieldset>
</form>

</cfoutput>

