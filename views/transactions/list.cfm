<cfset process = event.getArg('process') />
<cfset transactions = event.getArg('transactions') />
<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfoutput>


<h1>Transaction History</h1>

<cfinvoke method="process_details" process="#process#" />

<cfif transactions.length() GT 0>
<table>
	<tr>
		<th>Transaction Time</th>
		<th>User</th>
		<th>Activity</th>
		<th>Field</th>
		<th>Old Value</th>
		<th>New Value</th>
	</tr>
	<cfloop condition="#transactions.next()#">
		<cfset transaction = transactions.current() />
		<tr>
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
	<p>No transactions were found</p>
</cfif>

</cfoutput>