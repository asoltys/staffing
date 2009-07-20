<cfoutput>

<cfinclude template="search_form.cfm" />

<p class="group">
Displaying <strong>#positions.length()#</strong> Positions 
<cfif structKeyExists(session, 'params')>
  (<a href="#request.path#index.cfm?event=positions.staffing_log&amp;refresh=1">Show All / Refresh</a>)
</cfif>
</p>

<cfif request.current_user.hasRole("HR Staff")>
	<p>
		<a href="#request.path#index.cfm?event=positions.form" class="addLink">Enter a new Position</a>
		<a id="assign_staff" class="editLink">Manage Position Assignments</a>
	</p>
</cfif>

<cfif positions.length() GT 0>
	<cfloop query="groups">
		<cfinvoke method="filter_positions" event="#event#" returnvariable="filtered_positions" />
		<cfif filtered_positions.length() GT 0>
			<div class="branch">
				<h1 class="hr">#display# (#filtered_positions.length()# Position<cfif filtered_positions.length() GT 1>s</cfif>)</h1>
				<table class="positions" id="positions">
					<cfinvoke method="position_header" />
					<cfloop condition="#filtered_positions.next()#">
						<cfinvoke method="position_row" position="#filtered_positions.current()#">
					</cfloop>
				</table>
			</div>
			<br />
		</cfif>
 	</cfloop>
	<cfinvoke method="legend" />
<cfelse>
	<p class="warning">
		No positions matched the selected criteria
	</p>
</cfif>

</cfoutput>
