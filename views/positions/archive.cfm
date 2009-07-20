<cfoutput>

<cfquery name="date_range" datasource="#request.dsn#">
	SELECT 
		min(fiscal_year) AS min 
	FROM positions
</cfquery>

<cfset start_year = date_range.min />
<cfset end_year = Year(Now()) - 1 />

<ul>
	<cfloop from="#end_year#" to="#start_year#" index="year" step="-1">
	<cfset next_year = year + 1 />
	<li>
		<a href="#request.path#index.cfm?event=positions.staffing_archive&amp;archived=true&amp;fiscal_year=#year#&refresh=1">
		Fiscal Year #year#-#next_year#
		</a>
	</li>
	</cfloop>
</ul>
	
</cfoutput>

