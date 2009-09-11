<cfset request.current_user = request.current_user />
<cfset position = event.getArg('position') />
<cfset titles = event.getArg('titles') />
<cfset language_considerations = event.getArg('language_considerations') />
<cfset locations = event.getArg('locations') />
<cfset managers = event.getArg('managers') />
<cfset staffing_methods = event.getArg('staffing_methods') />
<cfset security_levels = event.getArg('security_levels') />
<cfset tenures = event.getArg('tenures') />
<cfset errors = event.getArg('errors') />

<cfinclude template="form_scripts.cfm" />
<cfinclude template="#request.includes_path#includes/helpers.cfm">

<cfoutput>

<h1>Position Form</h1>

<cfinvoke method="displayErrors" />

<h2>Which job does this position fulfill?</h2>
<form>
	<label>Job Title</label>
	<select id="title">
		<cfloop query="titles">
			<cfset selected = "" />
			<cfif titles.title EQ position.job.title>
				<cfset selected = "selected=""selected""" />
			</cfif>
		<option value="#titles.title#" #selected#>#titles.title#</option>
		</cfloop>
	</select>
	
	<br /><br />
	
	<label>Classification</label>
	<select id="classification">
		<option value="">Select One</option>
	</select>
	
	<br /><br />
	
	<label>Level</label>
	<select id="classification_level">
		<option value="">Select One</option>
	</select>
	
	<br /><br />
	
	<label>Branch</label>
	<select id="branch">
		<option value="">Select One</option>
	</select>
</form>
<p>
	Can't find the job you're looking for?  You may need to add it on the <a href="#request.path#index.cfm?event=jobs.list">job management</a> page.
</p>

<h2>Position Details</h2>
		
<form action="index.cfm?event=positions.process" method="post">
	<input id="id" name="id" type="hidden" value="#position.id#" />
	<input id="job_id" name="job_id" type="hidden" value="#position.job_id#" />
	<input id="process_id" name="process_id" type="hidden" value="#position.process_id#" />
	
	<label for="location">Location</label>
	<select name="location" id="location">
		<option value="">Select One</option>
		<cfloop condition="#locations.next()#">
			<cfset location = locations.current() />
			<cfif position.location eq location.name>
				<cfset selected = 'selected = "selected"' />
			<cfelse>
				<cfset selected = '' />
			</cfif>
			<option value="#location.name#" #selected#>#location.name#</option>
		</cfloop>
	</select>
	<br /><br />
	
	<label for="manager_id">Manager:</label>
	<select id="manager_id" name="manager_id">
		<option value="">None</option>
		<cfloop condition="#managers.next()#">
			<cfset manager = managers.current() />
			
			<cfset selected = "" />
			<cfif manager.id EQ position.manager_id>
				<cfset selected = "selected=""selected""" />
			</cfif>
				
			<option value="#manager.id#" #selected#>
				#manager.getName()#
			</option>
		</cfloop>
	</select>
	
	<br /><br />
	
	<label for="number">Position Number</label>
	<input id="number" name="number" type="text" value="#position.number#" />
		
	<br /><br />
	
	<label for="tenure_id">Tenure:</label>
	<select id="tenure_id" name="tenure_id">
		<option value="">Select One</option>
		<cfloop condition="#tenures.next()#">
			<cfset tenure = tenures.current() />
			<cfset selected = "" />
			<cfif tenure.id EQ position.tenure_id>
				<cfset selected = "selected=""selected""" />
			</cfif>
				
			<option value="#tenure.id#" #selected#>#tenure.name#</option>
		</cfloop>
	</select>
	
	<br /><br />
	
	<label for="security_level_id">Security Level</label>
	<select id="security_level_id" name="security_level_id">
		<option value="">Select One</option>
		<cfloop condition="#security_levels.next()#">		
			<cfset security_level = security_levels.current() />
			<cfset selected = "" />
			<cfif security_level.id EQ position.security_level_id>
				<cfset selected = "selected=""selected""" />
			</cfif>
				
			<option value="#security_level.id#" #selected#>#security_level.name#</option>
		</cfloop>
	</select>
	
	<br /><br />
	
					
	<label for="language_consideration_id">Language Considerations</label>
	<select name="language_consideration_id" id="language_consideration_id">
		<option value="">Select One</option>
		<cfloop condition="#language_considerations.next()#">
			<cfset language_consideration = language_considerations.current() />
			<cfif position.language_consideration_id eq language_consideration.id>
				<cfset selected = 'selected = "selected"' />
			<cfelse>
				<cfset selected = '' />
			</cfif>
			<option value="#language_consideration.id#" #selected#>#language_consideration.name#</option>
		</cfloop>
	</select>	
			
	<br /><br />	
	
	<label for="fiscal_year">Staffing Plan Fiscal Year</label>
	<select id="fiscal_year" name="fiscal_year">
    <cfset end_year = year(now()) + 1 />
    <cfset start_year = 2007 />

		<cfloop from="#end_year#" to="#start_year#" index="curr_year" step="-1">
			<cfset selected = "" />
			<cfset next_year = curr_year + 1 />
			<cfif curr_year EQ position.fiscal_year>
				<cfset selected = "selected=""selected""" />
			</cfif>
			
			<option value="#curr_year#" #selected#>#curr_year#-#next_year#</option>
		</cfloop>
	</select>
	
	<br /><br />

  <label for="infrastructure">Infrastructure Position</label>
  <cfif position.forInfrastructure()>
    <cfset checked= "checked=""checked""" />
  <cfelse>
    <cfset checked = "" />
  </cfif>
  <input type="checkbox" id="infrastructure" name="infrastructure" value="1" #checked# />
	<br /><br />
	
	<label for="rationale">Rationale</label>
	<textarea id="rationale" name="rationale">#position.rationale#</textarea>
	
	<br /><br />
	
	<label for="comments">Comments</label>
	<textarea id="comments" name="comments">#position.comments#</textarea>
	
	<br /><br />
	<input type="submit" name="submit_button" id="submit_button" value="Submit" class="submitButton"/>
</form>

</cfoutput>
