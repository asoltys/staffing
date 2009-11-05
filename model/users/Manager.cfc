<cfcomponent extends="User">
	<cffunction name="configure" access="private" returntype="void">
		<cfset super.configure() />

		<cfset hasMany('positions', 'hr_staffing.model.positions.Position', 'position') />
		<cfset hasMany('transactions', 'hr_staffing.model.transactions.Transaction', 'transaction') />
	</cffunction>
	
<!----------------------------------------------------------------------------------- readTransactions

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="readTransactions" access="public" returntype="void">
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT TOP 10
				transactions.id AS transaction_id,
				transactions.user_id AS transaction_user_id,
				transactions.datetime AS transaction_datetime,
				transactions.old_value AS transaction_old_value,
				transactions.new_value AS transaction_new_value,
				transactions.action AS transaction_action,
				common_login..users.first_name AS user_first_name,
				common_login..users.last_name AS user_last_name,
				processes_staffing_activities.id AS process_activity_id,
				processes.id AS process_id,
				processes.number AS process_number,
				staffing_activities.name AS activity_name
			FROM processes
			JOIN processes_staffing_activities
			  ON processes_staffing_activities.process_id = processes.id
			JOIN staffing_activities
				ON processes_staffing_activities.activity_id = staffing_activities.id
			JOIN transactions
			  ON processes_staffing_activities.id = transactions.process_activity_id
			JOIN staffing_users 
				ON staffing_users.id = transactions.user_id
			JOIN common_login..users
				ON common_login..users.login = staffing_users.login
			JOIN positions
			  ON positions.process_id = processes_staffing_activities.process_id
			WHERE positions.manager_id =
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			ORDER BY transactions.[datetime] DESC
		</cfquery>
		
		<cfset this.transactions.setQuery(query) />
	</cffunction>
</cfcomponent>