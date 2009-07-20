<cfif NOT event.isArgDefined('fiscal_year')>
	<cfset event.setArg('fiscal_year', Year(DateAdd('m', -3, Now()))) />
</cfif>

<cfset selected_year = event.getArg('fiscal_year') />
<cfset previous_year = selected_year - 1 />

<cfquery name="positions" datasource="#request.dsn#">
	SELECT
		jobs.branch,
		COALESCE(statuses.name, 'Not Started') AS status,
		count(*) AS num_positions
	FROM positions
	LEFT JOIN processes
		ON positions.process_id = processes.id
	LEFT JOIN statuses
		ON processes.status_id = statuses.id
	JOIN jobs
		ON positions.job_id = jobs.id
	WHERE 
	(
		positions.fiscal_year = <cfqueryparam value="#selected_year#" cfsqltype="cf_sql_varchar" />
		OR YEAR(DATEADD(m, -3, processes.completion_date)) = <cfqueryparam value="#selected_year#" cfsqltype="cf_sql_varchar" />
		OR YEAR(DATEADD(m, -3, processes.cancelation_date)) = <cfqueryparam value="#selected_year#" cfsqltype="cf_sql_varchar" />
		OR 
		(
			processes.completion_date IS NULL AND processes.cancelation_date IS NULL
			AND <cfqueryparam value="#selected_year#" cfsqltype="cf_sql_varchar" /> = <cfqueryparam value="#Year(DateAdd('m', -3, Now()))#" cfsqltype="cf_sql_varchar" />
		)
	)
	GROUP BY statuses.name, jobs.branch
</cfquery>

<cfquery name="statuses" dbtype="query">
	SELECT DISTINCT
		status
	FROM positions
</cfquery>

<cfset statusColours = structNew() />
<cfset statusColours['Not Started'] = "##DDDDDD" />
<cfset statusColours['In Progress'] = "##ACD896" />
<cfset statusColours['At Risk'] = "##F5EF9C" />
<cfset statusColours['Late'] = "##EBB1B1" />
<cfset statusColours['Completed'] = "##999999" />
<cfset statusColours['Canceled'] = "##d3e0eb" />

<cfquery name="date_range" datasource="#request.dsn#">
	SELECT 
		max(fiscal_year) AS max, 
		min(fiscal_year) AS min 
	FROM positions
</cfquery>

<cfset start_year = date_range.min />
<cfset end_year =date_range.max />

<cfoutput>

<script type="text/javascript" language="javascript">
	Event.observe(window, 'load', function() {
		$('fiscal_year').observe('change', function(e) {
			window.location.href = setURLparam('fiscal_year', e.element().value, window.location.href) 
		})
	})
</script>

<h1>Branch Breakdown</h1>

<p>
	Currently displaying statistics for fiscal year:
	<select id="fiscal_year" name="fiscal_year" style="width: 150px;">
		<cfloop from="#end_year#" to="#start_year#" index="year" step="-1">
		<cfset next_year = year + 1 />
		<cfset selected = "" />
		<cfif event.getArg('fiscal_year') EQ year>
			<cfset selected = "selected=""selected""" />
		</cfif>
		<option value="#year#" #selected#>#year#-#next_year#</option>
	</cfloop>
</select>
</p>

<cfchart format="flash" chartwidth="700" xaxistitle="Branches" yaxistitle="Positions" showlegend="yes">
	<cfloop query="statuses">
		<cfquery name="counts" dbtype="query">
			SELECT 
				branch, 
				num_positions
			FROM positions
			WHERE status = '#statuses.status#'
		</cfquery>

		<cfchartseries type="bar" query="counts" itemcolumn="branch" valuecolumn="num_positions" serieslabel="#statuses.status#" seriescolor="#statusColours[statuses.status]#" />	
	</cfloop>
</cfchart>

</cfoutput>