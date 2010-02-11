<cfoutput>

<cfhtmlhead text="<script src=""#request.path#scripts/search_form.js"" language=""javascript"" type=""text/javascript""></script>" />

<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="noPrint" id="search_form">
	<div id="expand_search">
		<a id="search_header" href="##">Search</a>
	</div>
	<fieldset id="search_fields" style="display: none;">	
		<input id="user_id" name="user_id" type="hidden" value="#event.getArg('user_id')#" />
		<input id="current_classification_level_id" name="current_classification_level_id" type="hidden" value="#event.getArg('classification_level_id')#" />
		<input id="current_location" name="current_location" type="hidden" value="#event.getArg('location')#" />
		
		<h2>Filter Criteria</h2>
		
		<label for="classification_id">Classification</label>
		<select id="classification_id" name="classification_id">
			<option value="">All</option>
			<cfloop condition="#classifications.next()#">
				<cfset classification = classifications.current() />
				<cfif classification.id eq event.getArg('classification_id')>
					<cfset selected = 'selected="selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#classification.id#" #selected#>#classification.name#</option>
			</cfloop>
		</select>
		<br /><br />
		
		<label for="classification_level_id">Level</label>
		<select id="classification_level_id" name="classification_level_id">
			<option value="">All</option>
		</select>
		<br /><br />
		
		<label for="branch">Branch</label>
		<select id="branch" name="branch">
			<br /><br />
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
		<br /><br />
    
    <label for="region_id">Region</label>
		<select id="region_id" name="region_id">
			<option value="">All</option>
			<cfloop condition="#regions.next()#">
				<cfset region = regions.current() />
				<cfif region.id eq event.getArg('region_id')>
					<cfset selected = 'selected="selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#region.id#" #selected#>#region.name#</option>
			</cfloop>
		</select>
		<br /><br />
		
		<label for="location">Location</label>
		<select id="location" name="location">
			<option value="">All</option>
			<cfloop condition="#locations.next()#">
				<cfset location = locations.current() />
				<cfif location.name eq event.getArg('location')>
					<cfset selected = 'selected="selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#location.name#" #selected#>#location.name#</option>
			</cfloop>
		</select>
		<br /><br />
		
		<label for="phase_id">Phase</label>
		<select id="phase_id" name="phase_id">
			<option value="">All</option>
			<cfloop condition="#phases.next()#">
				<cfset phase = phases.current() />
				<cfif phase.id eq event.getArg('phase_id')>
					<cfset selected = 'selected="selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#phase.id#" #selected#>#phase.name#</option>
			</cfloop>
		</select>
		<br /><br />
		
		<cfif request.current_user.hasRole("HR Staff,Manager")>
		
			<label for="status_id">Status</label>
			<select id="status_id" name="status_id">
				<option value="">All</option>
				<cfloop condition="#statuses.next()#">
					<cfset status = statuses.current() />
					<cfif status.id eq event.getArg('status_id')>
						<cfset selected = 'selected="selected"' />
					<cfelse>
						<cfset selected = '' />
					</cfif>
					<option value="#status.id#" #selected#>#status.name#</option>
				</cfloop>
			</select>
			<br /><br />
			
		</cfif>
		
		<label for="tenure_id">Tenure</label>
		<select id="tenure_id" name="tenure_id">
			<option value="">All</option>
			<cfloop condition="#tenures.next()#">
				<cfset tenure = tenures.current() />
				<cfif tenure.id eq event.getArg('tenure_id')>
					<cfset selected = 'selected="selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#tenure.id#" #selected#>#tenure.name#</option>
			</cfloop>
		</select>
		<br /><br />
		
		<label for="security_level_id">Security Level</label>
		<select id="security_level_id" name="security_level_id">
			<option value="">All</option>
			<cfloop condition="#security_levels.next()#">
				<cfset security_level = security_levels.current() />
				<cfif security_level.id eq event.getArg('security_level_id')>
					<cfset selected = 'selected="selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#security_level.id#" #selected#>#security_level.name#</option>
			</cfloop>
		</select>
		<br /><br />
		
		<label for="staffing_method_id">Staffing Method</label>
		<select id="staffing_method_id" name="staffing_method_id">
			<option value="">All</option>
			<cfloop condition="#staffing_methods.next()#">
				<cfset staffing_method = staffing_methods.current() />
				<cfif staffing_method.id eq event.getArg('staffing_method_id')>
					<cfset selected = 'selected="selected"' />
				<cfelse>
					<cfset selected = '' />
				</cfif>
				<option value="#staffing_method.id#" #selected#>#staffing_method.name#</option>
			</cfloop>
		</select>
		<br /><br />
		
		<label for="collective">Collective Processes</label>
		<select id="collective" name="collective">
			<option value="">All Processes</option>
			<option value="1" <cfif event.getArg('collective') EQ 1>selected="selected"</cfif>>Collective Processes Only</option>
			<option value="0" <cfif event.getArg('collective') EQ 0>selected="selected"</cfif>>Non-Collective Processes Only</option>
		</select>
		<br /><br />

    <label for="infrastructure">Infrastructure Positions</label>
		<select id="infrastructure" name="infrastructure">
			<option value="">All</option>
			<option value="1" <cfif event.getArg('infrastructure') EQ 1>selected="selected"</cfif>>Infrastructure Positions Only</option>
			<option value="0" <cfif event.getArg('infrastructure') EQ 0>selected="selected"</cfif>>Non-Infrastructure Positions Only</option>
		</select>
		<br /><br />
		
		<h2>Display Criteria</h2>
		
		<label for="group_by">Group By</label>
		<select id="group_by" name="group_by">
			<option value="branch_acronym" <cfif event.getArg('group_by') EQ 'branch_acronym'>selected="selected"</cfif>>Branch</option>
			<option value="manager_id" <cfif event.getArg('group_by') EQ 'manager_id'>selected="selected"</cfif>>Manager</option>
			<option value="fiscal_year" <cfif event.getArg('group_by') EQ 'fiscal_year'>selected="selected"</cfif>>Planned Year</option>
		</select>
		<br /><br />
		
		<label for="order_by">Order By</label>
		<select id="order_by" name="order_by">
			<cfloop list="#structKeyList(event.getArg('orderings'), '@')#" index="ordering" delimiters="@">
				<cfset selected = '' />
				<cfif event.getArg('order_by') EQ orderings[ordering]>
					<cfset selected = 'selected="selected"' />
				</cfif>
				<option value="#orderings[ordering]#" #selected#>#ordering#</option>
			</cfloop>
		</select>
		<br /><br />
		
		<label for="direction">Order Direction</label>
		<select id="direction" name="direction">
				<option value="ASC" <cfif event.getArg('direction') EQ 'DESC'>selected="selected"</cfif>>Ascending</option>
				<option value="DESC" <cfif event.getArg('direction') EQ 'ASC'>selected="selected"</cfif>>Descending</option>
		</select>
		<br /><br />
		
		<input name="search" type="submit" value="Search" class="submitButton submitRight" />
		
	</fieldset>
</form>

</cfoutput>
