<!---------------------------------------------------------------------------------- Helper Javascript

	Description:	This script runs on window.load to decorate certain HTML elements with specialized
								onclick handlers

----------------------------------------------------------------------------------------------------->


<!-------------------------------------------------------------------------------------- displayErrors

	Description:	This function loops over a collection of errors and displays them in a list

----------------------------------------------------------------------------------------------------->

<cffunction name="displayErrors" access="public" returntype="void" output="true">
	<cfif isStruct(errors) AND StructCount(errors) GT 0>
		<div class="pageError">
			<h1>There was a problem submitting the form:</h1>
			<ul>
				<cfloop list="#StructKeyList(errors)#" index="key">
					<li>#errors[key]#</li>
				</cfloop>
			</ul>
		</div>
		<br />
	</cfif>
</cffunction>

<!----------------------------------------------------------------------------------- filter_positions

	Description:	Specialized helper function used by staffing log page to narrow down position list
								based on selected grouping parameter

----------------------------------------------------------------------------------------------------->

<cffunction name="filter_positions" access="public" returntype="supermodel.objectlist">
	<cfargument name="event" type="any" required="yes" />

	<cfset var filtered_positions = positions.copy() />

	<cfset variables.value = Evaluate("groups.#event.getArg('group_by')#") />
	<cfset variables.display = Evaluate("groups.#event.getArg('group_display_col')#") />

	<cfif value EQ "">
		<cfset conditions = "0 = 1" />
	<cfelse>
		<cfif NOT isNumeric(value) OR event.getArg('group_by') EQ "fiscal_year">
			<cfset value = "'#value#'" />
		</cfif>

		<cfset conditions = "#event.getArg('group_by')# = #PreserveSingleQuotes(value)#" />
	</cfif>

	<cfset filtered_positions.filter(conditions) />

	<cfreturn filtered_positions />
</cffunction>

<!------------------------------------------------------------------------------------ position_header

	Description:	Outputs an HTML table row with column headers for a position object

----------------------------------------------------------------------------------------------------->

<cffunction name="position_header" access="public" returntype="void" output="true">
	<cfset var columnHeadings = "Position Number,Group / Level,Title,Year,Phase" />

	<tr>
		<cfloop list="#columnHeadings#" index="heading">
			<th><a>#heading#</a></th>
		</cfloop>
	</tr>

</cffunction>

<!--------------------------------------------------------------------------------------- position_row

	Description:	Outputs an HTML table row with data columns for a position object

----------------------------------------------------------------------------------------------------->

<cffunction name="position_row" access="public" returntype="void" output="true">
	<cfargument name="position" type="hr_staffing.model.positions.position" required="yes" />
	<cfargument name="displayProcess" type="boolean" default="true" />
	
	<tr id="toggle_#position.id#" class="detailsToggle #position.process.getStatusClass(request.current_user)#">
		<td>#position.number#</td>
		<td>#position.job.groupAndLevel()#</td>
		<td>#position.job.title#</td>
		<td>#position.fiscal_year#</td>
		<td>#position.phase()# <br />
		</td>
	</tr>
	<!---<tr class="hidden" id="details_#position.id#">
		<td colspan="6" id="td_details">

		</td>
	</tr>--->
</cffunction>

<!----------------------------------------------------------------------------------- job_details

	Description:	Outputs an HTML table displaying all the details of a position

----------------------------------------------------------------------------------------------------->

<cffunction name="job_details" access="public" returntype="void" output="true">
	<cfargument name="position" type="hr_staffing.model.positions.position" required="yes" />
	<cfargument name="displayStatus" type="boolean" default="true" />

	<table class="job_details <cfif displayStatus>#position.process.getStatusClass(request.current_user)#</cfif>">
		<tr class="hideEmail">
			<th colspan="4">
				Job
				<br />
				<cfif position.job.display EQ true>
					<span class="navigation">
						<a href="#request.competency_path#index.cfm?event=jobs.job_profile&id=#position.job.id#&role=public">
						Job Profile
						</a>
						|
						<a href="#request.competency_path#index.cfm?event=jobs.competency_profile&id=#position.job.id#&role=public">
						Competency Profile
						</a>
						|
						<a href="#request.competency_path#index.cfm?event=jobs.learning_profile&id=#position.job.id#&role=public">
						Learning Profile
						</a>
					</span>
				</cfif>
			</th>
		</tr>
		<tr>
			<td><strong>Title</strong></td>
			<td>#position.job.title#</td>
			<td><strong>Group/Level</strong></td>
			<td>#position.job.groupAndLevel()#</td>
		</tr>
		<tr>
			<td><strong>Branch</strong></td>
			<td>#position.job.branch#</td>
			<td><strong>Location</strong></td>
			<td>#position.location.name#</td>
		</tr>
	</table>
</cffunction>

<!----------------------------------------------------------------------------------- position_details

	Description:	Outputs an HTML table displaying all the details of a position

----------------------------------------------------------------------------------------------------->

<cffunction name="position_details" access="public" returntype="void" output="true">
	<cfargument name="position" type="hr_staffing.model.positions.position" required="yes" />
	<cfargument name="displayStatus" type="boolean" default="true" />

	<table id="position_details_#position.id#" class="position details <cfif displayStatus>#position.process.getStatusClass(request.current_user)#</cfif>">
		<tr class="hideEmail">
			<th colspan="4">
				Position
				<br />
				<span class="navigation">
					<cfif request.current_user.hasRole('HR Staff')>
						<cfif position.process.status.name neq 'canceled'>
							<a href="#request.path#index.cfm?event=positions.set_process&amp;position_id=#position.id#">
								Specify Process
							</a>
							|
							<a href="#request.path#index.cfm?event=positions.form&amp;id=#position.id#">Edit Position</a>
							|
						</cfif>
						<a href="#request.path#index.cfm?event=positions.delete&amp;id=#position.id#" class="deleteLink">Delete Position</a>
					</cfif>
				</span>
			</th>
		</tr>
		<tr>
			<td><strong>Position Number</strong></td>
			<td><cfif position.number NEQ "">#position.number#<cfelse>Not Specified</cfif></td>
			<td><strong>Fiscal Year</strong></td>
			<td>#position.fiscal_year#</td>
		</tr>
		<tr>
			<td><strong>Tenure</strong></td>
			<td>#position.tenure.name#</td>
			<td><strong>Official Language</strong></td>
			<td>#position.language_consideration.name#</td>
		</tr>
		<tr>
			<td><strong>Security Level</strong></td>
			<td>#position.security_level.name#</td>
			<td><strong>Manager</strong></td>
			<td>
				<a href="mailto:#position.manager.email#">
					#position.manager.getName()#
				</a>
			</td>
		</tr>
		<tr class="hideEmail">
			<td><strong>Infrastructure</strong></td>
			<td>#position.forInfrastructure()#</td>
			<td><strong>HR Contacts</strong></td>
			<td>
				
				<cfif position.assignees.length() GT 0>
				  <cfloop condition="#position.assignees.next()#">
					<a href="mailto:#position.assignees.current().email#">
					  #position.assignees.current().getName()#
					</a><br />
				  </cfloop>
				<cfelse>
					<p>
						There are currently no staff members assigned to this position
					</p>
				</cfif>
			</td>
		</tr>
	</table>
</cffunction>

<!------------------------------------------------------------------------------------ process_details

	Description:	Outputs an HTML table displaying all the details of a process

----------------------------------------------------------------------------------------------------->

<cffunction name="process_details" access="public" returntype="void" output="true">
	<cfargument name="process" type="hr_staffing.model.processes.process" required="no" />
	<cfargument name="displayPositions" type="boolean" default="false" />

	<table id="process_details_#process.id#" class="process details #process.getStatusClass(request.current_user)#">
		<tr class="hideEmail">
			<th colspan="4">
				Process
				<br />
				<span class="navigation">
					<cfif request.current_user.hasRole('HR Staff')>
						<a href="#request.path#index.cfm?event=processes.form&id=#process.id#">
							Edit Process
						</a>
						|
					</cfif>
					<a href="#request.path#index.cfm?event=processes.ssda&process_id=#process.id#">
						Staffing Activities
					</a>
					<cfif request.current_user.hasRole('HR Staff,Manager')>
						|
						<a href="#request.path#index.cfm?event=transactions.list&process_id=#process.id#">
							Transaction History
						</a>
					</cfif>
				</span>
			</th>
		</tr>
		<tr>
			<td><strong>Selection Process Number</strong></td>
			<td>#process.number#</td>
			<td><strong>Board Chair</strong></td>
			<td>#process.board_chair.getName()#</td>
		</tr>
		<tr>
			<td><strong>Staffing Method</strong></td>
			<td>#process.staffing_method.name#</td>
			<td><strong>Collective Process</strong></td>
			<td>#process.isCollectiveProcess()#</td>
		</tr>
		<cfif request.current_user.hasRole('Manager,HR Staff')>
		<tr>
			<td><strong>Status</strong></td>
			<td id="process_status_#process.id#">#process.status.name#</td>
			<td><strong>Phase</strong></td>
			<td id="process_phase_#process.id#">#process.phase.name#</td>
		</tr>
		</cfif>
		<cfif displayPositions>
			<cfset positions = process.getPositions() />
			<tr>
				<td colspan="4">
					<table id="process_positions_#process.id#">
						<tr>
							<th colspan="6">Positions</th>
						</tr>
						<cfloop condition="#positions.next()#">
							<tr>
							<cfinvoke method="position_row" position="#positions.current()#" displayProcess="false" />
							</tr>
						</cfloop>
					</table>
				</td>
			</tr>
		</cfif>
	</table>
</cffunction>

<!--------------------------------------------------------------------------------------------- legend

	Description:	Outputs a legend that describes the meaning of the position colour-codings

----------------------------------------------------------------------------------------------------->

<cffunction name="legend" access="public" returntype="void" output="true">
<table id="colour_key">
	<tr>
		<th>Legend</th>
	</tr>
	<tr class="not_started">
		<td>The staffing process for the position has not been started</td>
	</tr>
	<tr class="in_progress">
		<td>The staffing process for the position has started <cfif request.current_user.hasRole('HR Staff,Manager')>and is on time</cfif></td>
	</tr>
	<cfif request.current_user.hasRole('HR Staff,Manager')>
	<tr class="at_risk">
		<td>The staffing process for the position is in danger of running behind schedule</td>
	</tr>
	<tr class="late">
		<td>The staffing process for the position is behind schedule</td>
	</tr>
	</cfif>
	<tr class="canceled">
		<td>The staffing process for the position has been canceled</td>
	</tr>
	<tr class="completed">
		<td>The staffing process for the position has been completed</td>
	</tr>
</table>
</cffunction>

<!----------------------------------------------------------------------------------------- Capitalize

	Description: Capitalizes the first letter of the given string

----------------------------------------------------------------------------------------------------->

<cffunction name="Capitalize" access="public">
	<cfargument name="string" type="string" required="yes" />

	<cfset arguments.string =
		Left(UCase(arguments.string), 1)
		&
		Right(LCase(arguments.string), Len(arguments.string) - 1) />
	<cfreturn arguments.string />
</cffunction>

<!-------------------------------------------------------------------------------- modifyQueryString

	Description: Inserts or updates a key/value pair in the query string

----------------------------------------------------------------------------------------------------->

<cffunction name="modifyQueryString">
	<cfargument name="key" required="yes" />
	<cfargument name="value" required="yes" />
	<cfargument name="queryString" default="#CGI.QUERY_STRING#" />

	<cfset value = URLEncodedFormat(value) />

	<cfif Find(key, queryString) EQ 0>
		<cfif queryString NEQ "">
			<cfset queryString = "#queryString#&#key#=#value#" />
		<cfelse>
			<cfset queryString = "#key#=#value#" />
		</cfif>
	<cfelse>
		<cfset queryString =  REReplace(queryString, "#key#=[^&]*", "#key#=#value#", "one") />
	</cfif>

	<cfreturn queryString />
</cffunction>

<!------------------------------------------------------------------------------------------- paginate

	Description: Adds pagination controls to the top of a table in order to break up large queries

----------------------------------------------------------------------------------------------------->

<cffunction name="paginate" access="public" returntype="void" output="true">
	<cfargument name="list" type="supermodel.objectlist" required="yes" />
	<cfargument name="event" />

	<!--- Default values --->
	<cfset var totalrows = list.length() />
	<cfset var page = 1 />
	<cfset var offset = 10 />
	<cfset var lastpage = 1 />
	<cfset variables.startrow = 1 />
	<cfset variables.endrow = 1 />

	<cfif event.isArgDefined('page')>
		<cfset page = event.getArg('page') />
	</cfif>

	<cfif event.isArgDefined('offset')>
		<cfset offset = event.getArg('offset') />
	</cfif>

	<cfset arguments.list.paginate(page, offset) />

	<cfset lastpage = ceiling(totalrows/offset) />
	<cfset startrow = ((page - 1) * offset) + 1>
	<cfset endrow = startrow + offset - 1>

	<p>
	<cfif page NEQ 1>
		<cfset queryString = modifyQueryString('page', page - 1) />
		<a href="#CGI.SCRIPT_NAME#?#queryString#">Previous Page</a>
	<cfelse>
		Previous Page
	</cfif>

	| <span id="page_num">Page #page# of #lastpage#</span> |

	<cfif page LT lastpage>
		<cfset queryString = modifyQueryString('page', page + 1) />
		<a href="#CGI.SCRIPT_NAME#?#queryString#">Next Page</a>
	<cfelse>
		Next Page
	</cfif>
 </p>

 <p>
	 Records per page:
	 <select onchange="window.location=this.value">
		<cfloop from="1" to="5" index="i">
			<cfset increment = i * 10 />
			<cfset queryString = modifyQueryString('page', ceiling(startrow / increment)) />
			<cfset queryString = modifyQueryString('offset', increment, queryString) />
			<option value="#CGI.SCRIPT_NAME#?#queryString#"<cfif offset EQ increment> selected="selected"</cfif>>#increment#</option>
		</cfloop>
		</select>
		Jump to page:
		<select onchange="window.location=this.value">
			<cfloop index="i" from="1" to="#lastpage#" step="1">
			<cfset queryString = HTMLEditFormat(modifyQueryString('page', i)) />
			<option value="#CGI.SCRIPT_NAME#?#queryString#"<cfif page EQ i> selected="selected"</cfif>>#i#</option>
		</cfloop>
		</select>
	</p>
</cffunction>

<cffunction name="getColourList" access="public" returntype="string">
	<cfargument name="statuses" type="string" required="yes" />

	<cfset var colourList = "" />
	<cfset var statusColours = structNew() />
	<cfset statusColours['Not Started'] = "##DDDDDD" />
	<cfset statusColours['In Progress'] = "##ACD896" />
	<cfset statusColours['At Risk'] = "##F5EF9C" />
	<cfset statusColours['Late'] = "##EBB1B1" />
	<cfset statusColours['Completed'] = "##999999" />
	<cfset statusColours['Canceled'] = "##d3e0eb" />


	<cfloop list="#arguments.statuses#" index="status">
		<cfset colourList = ListAppend(colourList, statusColours[status]) />
	</cfloop>

	<cfreturn colourList />
</cffunction>
