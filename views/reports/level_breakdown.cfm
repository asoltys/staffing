<cfif NOT event.isArgDefined('fiscal_year')>
	<cfset event.setArg('fiscal_year', Year(DateAdd('m', -3, Now()))) />
</cfif>

<cfset selected_year = event.getArg('fiscal_year') />

<cfquery name="master_query" datasource="#request.dsn#">
	SELECT
		classifications.name AS classification_name,
		classification_levels.name AS classification_level_name,
		statuses.name AS status,
		positions.fiscal_year
	FROM
	positions
	JOIN jobs
	ON positions.job_id = jobs.id
	JOIN classification_levels 
	ON jobs.classification_level_id = classification_levels.id
	JOIN classifications
	ON classifications.id = classification_levels.classification_id
	LEFT JOIN processes
	ON positions.process_id = processes.id
	JOIN statuses
	ON processes.status_id = statuses.id
	WHERE positions.fiscal_year = 
		<cfqueryparam value="#selected_year#" cfsqltype="cf_sql_varchar" />
	OR YEAR(processes.completion_date) = 
		<cfqueryparam value="#selected_year#" cfsqltype="cf_sql_varchar" />
	<cfif selected_year EQ Year(DateAdd('m', -3, Now()))>
	OR processes.completion_date IS NULL
	</cfif>
</cfquery>

<cfquery name="classifications" dbtype="query">
	SELECT 
		classification_name AS name, 
		count(*) AS total
	FROM master_query
	GROUP BY classification_name
</cfquery>

<cfquery name="statuses" dbtype="query">
	SELECT DISTINCT 
		status AS name
	FROM master_query
	WHERE status != ''
</cfquery>

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

<h1>Level Breakdown</h1>

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

<table>	
	<tr>
		<th>&nbsp;</th>
		<cfloop query="statuses">
		<th>#statuses.name#</th>
		</cfloop>
		<th>Total</th>
	</tr>
	
	<cfloop query="classifications">
		<cfset classification = classifications.name />
		
		<cfquery name="classification_levels" dbtype="query">
			SELECT 
				classification_level_name AS name, 
				count(*) as total
			FROM master_query
			WHERE classification_name = '#classifications.name#'
			GROUP BY classification_level_name
		</cfquery>
		
		<cfloop query="classification_levels">
			<cfset classification_level = classification_levels.name />
			<tr>
				<td>#classification# - #classification_level#</td>
		
				<cfloop query="statuses">
					<cfset status = statuses.name />
					<cfquery name="positions" dbtype="query">
						SELECT count(*) AS num_records
						FROM master_query
						WHERE classification_name = '#classification#'
						AND classification_level_name = '#classification_level#'
						AND status = '#status#'
					</cfquery>
					<td>
						<cfif positions.num_records gt 0>#positions.num_records#<cfelse>-</cfif>
					</td>
				</cfloop>
				<td>#classification_levels.total#</td>
			</tr>
		</cfloop>

		<tr style="background-color: ##ddd">
			<td><strong>#classification#</strong></td>
	
			<cfloop query="statuses">
				<cfset status = statuses.name />
				<cfquery name="positions" dbtype="query">
					SELECT count(*) AS num_records
					FROM master_query
					WHERE classification_name = '#classification#'
					AND status = '#status#'
				</cfquery>
				<td>
					<cfif positions.num_records gt 0>#positions.num_records#<cfelse>-</cfif>
				</td>
			</cfloop>
			<td><strong>#classifications.total#</strong></td>
		</tr>
	</cfloop>
</table>

</cfoutput>