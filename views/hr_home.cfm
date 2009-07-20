<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfset staffer = createObject('component', 'hr_staffing.model.users.Staffer') />
<cfset staffer.init(request.dsn) />
<cfset staffer.read(request.current_user.id) />
<cfset staffer.readTransactions() />
<cfset transactions = staffer.transactions />

<cfquery name="statuses" datasource="#request.dsn#">
	SELECT
		COALESCE(statuses.name, 'Not Started') AS status,
		COUNT(positions.id) AS count
	FROM positions
	LEFT JOIN processes
	ON positions.process_id = processes.id
	LEFT JOIN statuses
	ON processes.status_id = statuses.id
	WHERE (positions.fiscal_year =
		<cfqueryparam value="#request.current_fiscal_year#" cfsqltype="cf_sql_varchar" />
	OR processes.completion_date IS NULL
	OR processes.cancelation_date IS NULL)
	AND positions.id IN (
		SELECT position_id
		FROM positions_users
		WHERE positions_users.user_id =
			<cfqueryparam value="#request.current_user.id#" cfsqltype="cf_sql_varchar" />
	)
	GROUP by statuses.name
</cfquery>

<cfset current_year = request.current_fiscal_year />
<cfset next_year = current_year + 1 />
<cfset request.current_fiscal_year = current_year & "-" & next_year />

<cfoutput>

<h1>Dashboard for HR Staff</h1>

<p>Welcome back #request.current_user.first_name#! <a href="#request.path#index.cfm?event=positions.staffing_log&amp;user_id=#request.current_user.id#">Click here</a> to be taken directly to the staffing log where you can view positions that you are currently assigned to.</p>

<h2>Position Summary</h2>

<cfif statuses.recordcount GT 0>
	<p>Here is a count of your positions, broken down by status, for the current fiscal year <strong>#request.current_fiscal_year#</strong>:</p>

	<cfchart format="flash" chartwidth="700" xaxistitle="Status" yaxistitle="Count">
		<cfchartseries type="pie" query="statuses" itemcolumn="status" valuecolumn="count" serieslabel="Position Status" colorlist="#getColourList(valueList(statuses.status))#" />
	</cfchart>

	<h2>Recent Activity</h2>

	<cfif transactions.length() GT 0>

		<p>
			The following table displays the latest updates that were made to the Staffing Service Delivery Agreements of processes that you are assigned to.  Click on the process number to view the SSDA for the process.
		</p>


		<table>
			<tr>
				<th>Process Number</th>
				<th>Transaction Time</th>
				<th>User</th>
				<th>Activity</th>
				<th>Field</th>
				<th>Old Value</th>
				<th>New Value</th>
			</tr>
			<cfloop condition="#transactions.next()#">
				<cfset transaction = transactions.current() />
				<cfset process_id = transaction.process_activity.process.id />
				<tr>
					<td><a href="#request.path#index.cfm?event=processes.ssda&process_id=#process_id#">#transaction.process_activity.process.number#</a></td>
					<td>#DateFormat(transaction.datetime, "yyyy-mm-dd")# #TimeFormat(transaction.datetime, "HH:mm")#</td>
					<td>#transaction.user.getName()#</td>
					<td>#transaction.process_activity.activity.name#</td>
					<td>#transaction.getAction()#</td>
					<td>#transaction.getValue('old_value')#</td>
					<td>#transaction.getValue('new_value')#</td>
				</tr>
			</cfloop>
		</table>
	<cfelse>

		<p>No recent activity was found for any of your positions.</p>

	</cfif>
<cfelse>
	<p>There are no positions assigned to you at this time</p>
</cfif>

</cfoutput>