<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfif NOT event.isArgDefined('fiscal_year')>
	<cfset event.setArg('fiscal_year', Year(DateAdd('m', -3, Now()))) />
</cfif>

<cfset selected_year = event.getArg('fiscal_year') />
<cfset previous_year = selected_year - 1 />

<cfquery name="positions" datasource="#request.dsn#">
	SELECT 
		positions.id, 
		COALESCE(statuses.name, 'Not Started') AS status,
		jobs.branch AS branch_name,
		positions.fiscal_year
	FROM positions
	LEFT JOIN processes 
	ON positions.process_id = processes.id
	JOIN jobs
	ON positions.job_id = jobs.id
	LEFT JOIN statuses
	ON processes.status_id = statuses.id
  LEFT JOIN positions_regions
  ON positions_regions.position_id = positions.id
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

  AND positions_regions.region_id = 
    <cfqueryparam value="#session.params.region_id#" cfsqltype="cf_sql_integer" />
	ORDER BY status
</cfquery>

<cfquery name="previous_positions" datasource="#request.dsn#">
	SELECT count(*) AS [count]
	FROM positions 
	LEFT JOIN processes 
	ON positions.process_id = processes.id
  LEFT JOIN positions_regions
  ON positions_regions.position_id = positions.id
	WHERE (positions.fiscal_year = 
		<cfqueryparam value="#previous_year#" cfsqltype="cf_sql_varchar" />
	OR YEAR(completion_date) = 
		<cfqueryparam value="#previous_year#" cfsqltype="cf_sql_varchar" />
	<cfif previous_year EQ Year(DateAdd('m', -3, Now()))>
	OR processes.completion_date IS NULL
	</cfif>)
  AND positions_regions.region_id = 
    <cfqueryparam value="#session.params.region_id#" cfsqltype="cf_sql_integer" />
</cfquery>

<cfquery name="carried_over" dbtype="query">
	SELECT *
	FROM positions
	WHERE fiscal_year < '#selected_year#'
</cfquery>

<cfset difference = positions.recordcount - previous_positions.count />

<cfif previous_positions.count NEQ 0>
	<cfset percent_increase = DecimalFormat((difference / previous_positions.count) * 100) & "%" />
<cfelse>
	<cfset percent_increase = 'INIFINITY!!!' />
</cfif>

<cfquery name="statuses" dbtype="query">
	SELECT status, COUNT(id) AS [count]
	FROM positions
	GROUP BY status
</cfquery>

<cfquery name="top_branch" dbtype="query">
	SELECT branch_name, COUNT(id) AS [count]
	FROM positions
	GROUP BY branch_name
	ORDER BY [count] DESC
</cfquery>
	
<cfquery name="date_range" datasource="#request.dsn#">
	SELECT 
		max(fiscal_year) AS max, 
		min(fiscal_year) AS min 
	FROM positions
  LEFT JOIN positions_regions
  ON positions_regions.position_id = positions.id
  WHERE positions_regions.region_id = 
    <cfqueryparam value="#session.params.region_id#" cfsqltype="cf_sql_integer" />
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


<h1>Bird's Eye View</h1>

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

<p>
	There were a total of <strong>#positions.recordcount#</strong> positions planned for this year which is <strong>#difference#</strong> more than the previous year -- an increase of <strong>#percent_increase#</strong>.
</p>

<p>
	Out of the <strong>#positions.recordcount#</strong> positions planned for this year, <strong>#carried_over.recordcount#</strong> of them were carried over from past years.
</p>

<p>
	The branch with the most positions currently planned is <strong>#top_branch.branch_name[1]#</strong> with <strong>#top_branch.count[1]#</strong> positions.
</p>

<p>
	Following is a breakdown of the current status of all positions planned for the year:
</p>

<cfchart format="flash" chartwidth="700" xaxistitle="Status" yaxistitle="Count">
	<cfchartseries type="pie" query="statuses" itemcolumn="status" valuecolumn="count" serieslabel="Position Status" colorlist="#getColourList(valueList(statuses.status))#" />	
</cfchart>

</cfoutput>
