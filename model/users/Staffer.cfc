<cfcomponent extends="hr_staffing.model.users.User">
	<cffunction name="configure" access="private" returntype="void">
		<cfset super.configure() />
		
		<cfset hasMany('positions', 'hr_staffing.model.positions.position', 'position') />
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
			JOIN positions_users
			  ON positions.id = positions_users.position_id
			WHERE positions_users.user_id =
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			ORDER BY transactions.[datetime] DESC
		</cfquery>
		
		<cfset this.transactions.setQuery(query) />
	</cffunction>
	
<!--------------------------------------------------------------------- getRecentlyEndangeredPositions

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getRecentlyEndangeredPositions" access="public" returntype="supermodel.ObjectList">
		<cfreturn getPositions("
			DATEADD
			(
				d, 
				processes_staffing_activities.endangered_time, 
				processes_staffing_activities.est_completion_date
			) 
			= @Now
			AND 
			processes_staffing_activities.completion_date IS NULL") />
	</cffunction>
	
<!--------------------------------------------------------------------------- getRecentlyLatePositions

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getRecentlyLatePositions" access="public" returntype="supermodel.ObjectList">
		<cfreturn getPositions("
		processes_staffing_activities.est_completion_date = @Now 
		AND 
		processes_staffing_activities.completion_date IS NULL") />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- getPositions

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getPositions" access="private" returntype="supermodel.ObjectList">
		<cfargument name="conditions" type="string" required="no" />
		
		<cfset var query = "" />
		<cfset var object = createObject('component', 'hr_staffing.model.positions.position')>
		<cfset var gateway = createObject('component', 'hr_staffing.model.positions.PositionGateway')>
		<cfset var list = createObject('component', 'supermodel.ObjectList') />
		<cfset object.init(variables.dsn) />
		<cfset gateway.init(variables.dsn) />
		<cfset query = gateway.select() />
		
		<cfquery name="positions" datasource="#variables.dsn#">
			DECLARE	@Now DATETIME;
			SET	@Now = DATEDIFF(DAY, '19000101', GETDATE());
	
			SELECT 
				positions.id
			FROM positions
			JOIN processes
				ON processes.id = positions.process_id
			JOIN processes_staffing_activities
				ON processes_staffing_activities.process_id = processes.id
			JOIN positions_users
				ON positions_users.position_id = positions.id
			WHERE positions_users.user_id =
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			<cfif structKeyExists(arguments, 'conditions')>
			AND #arguments.conditions#
			</cfif>
		</cfquery>
		
		<cfquery name="query" dbtype="query">
			SELECT * FROM query
			WHERE 
			<cfif positions.recordcount GT 0>
			id IN (#ValueList(positions.id)#)
			<cfelse>
			1 = 0
			</cfif>
		</cfquery>
		
		<cfset list.init(object, query) />
		<cfreturn list />
	</cffunction>
</cfcomponent>