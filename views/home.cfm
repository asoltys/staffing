<cfoutput>

<cfset position = createObject('component', 'hr_staffing.model.positions.Position') />

<cfset position.init(request.dsn) />

<cfif request.current_user.hasRole("HR Staff")>
	<p class="group">
		<a href="#request.path#index.cfm?event=home&amp;view=HR%20Staff" <cfif event.getArg('view') NEQ 'Manager'>class="active"</cfif>>Admin View</a> |
		<a href="#request.path#index.cfm?event=home&amp;view=Manager" <cfif event.getArg('view') EQ 'Manager'>class="active"</cfif>>Manager View</a>
	</p>
</cfif>

<cfif (event.isArgDefined('view') and event.getArg('view') eq "Manager") or request.current_user.hasRole("Manager")>
	<cfinclude template="manager_home.cfm" />
<cfelseif request.current_user.hasRole("HR Staff")>
	<cfinclude template="hr_home.cfm" />
<cfelse>
	<cfinclude template="employee_home.cfm" />
</cfif>

</cfoutput>