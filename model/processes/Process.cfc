<cfcomponent extends="supermodel.DataModel">
	<cffunction name="configure" access="public" returntype="void" >
		<cfset variables.table_name = 'processes' />
		<cfset belongsTo('board_chair', 'hr_staffing.model.users.User') />
		<cfset belongsTo('phase', 'hr_staffing.model.phases.Phase') />
		<cfset belongsTo('staffing_method', 'hr_staffing.model.staffing_methods.StaffingMethod') />
		<cfset belongsTo('status', 'hr_staffing.model.statuses.Status') />
		
		<cfset hasMany('comments', 'hr_staffing.model.comments.Comment', 'comment') />
		<cfset hasMany('transactions', 'hr_staffing.model.transactions.Transaction', 'transaction') />
		<cfset hasMany('process_activities', 'hr_staffing.model.process_activities.ProcessActivity', 'process_activity') />
		<cfset hasMany('positions', 'hr_staffing.model.positions.position', 'position') />
		
		<cfset this.collective = 0 />
	</cffunction>
	
<!-------------------------------------------------------------------------------------- readComments

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="readComments" access="public" returntype="void">
		<cfset var query = "" />
			
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				staffing_comments.id AS comment_id,
				staffing_comments.date AS comment_date,
				staffing_comments.user_id AS comment_user_id,
				staffing_comments.comment AS comment_comment
			FROM processes
			JOIN comments_processes
			  ON comments_processes.process_id = processes.id
			JOIN staffing_comments
				ON staffing_comments.id = comments_processes.comment_id
			WHERE processes.id =
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			ORDER BY staffing_comments.date DESC
		</cfquery>
		
		<cfset this.comments.setQuery(query) />
	</cffunction>
	
<!----------------------------------------------------------------------------- readProcessActivities

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="readProcessActivities" access="public" returntype="void">
		<cfset var query = "" />
			
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				processes_staffing_activities.id AS process_activity_id,
				processes_staffing_activities.activity_id process_activity_activity_id,
				processes_staffing_activities.process_id AS process_activity_process_id,
				processes_staffing_activities.status_id AS process_activity_status_id,
				processes_staffing_activities.est_completion_date AS process_activity_est_completion_date,
				processes_staffing_activities.completion_date AS process_activity_completion_date,
				processes_staffing_activities.endangered_time AS process_activity_endangered_time,
				staffing_activities.sequence AS activity_sequence,
				staffing_activities.name AS activity_name,
				staffing_activities.phase_id,
				phases.name AS phase_name,
				statuses.name AS status_name
			FROM processes
			JOIN processes_staffing_activities
			  ON processes_staffing_activities.process_id = processes.id
			JOIN statuses
			  ON processes_staffing_activities.status_id = statuses.id
			JOIN staffing_activities
				ON processes_staffing_activities.activity_id = staffing_activities.id
			JOIN phases
				ON staffing_activities.phase_id = phases.id
			WHERE processes.id =
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			ORDER BY staffing_activities.sequence
		</cfquery>
		
		<cfset this.process_activities.setQuery(query) />
	</cffunction>
	
<!----------------------------------------------------------------------------------- readTransactions

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="readTransactions" access="public" returntype="void">
		<cfset var query = "" />
			
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				transactions.id AS transaction_id,
				transactions.user_id AS transaction_user_id,
				transactions.datetime AS transaction_datetime,
				transactions.old_value AS transaction_old_value,
				transactions.new_value AS transaction_new_value,
				transactions.action AS transaction_action,
				common_login..users.first_name AS user_first_name,
				common_login..users.last_name AS user_last_name,
				processes_staffing_activities.id AS process_activity_id,
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
			WHERE processes.id =
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset this.transactions.setQuery(query) />
	</cffunction>
	
<!------------------------------------------------------------------------------------- getStatusClass

	Description:	
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getStatusClass" access="public" returntype="string">	
		<cfargument name="user" type="hr_staffing.model.users.User" required="yes" />
		<cfargument name="status" type="string" default="#this.status.name#" />
		
		<cfset var return_value = "not_started" />
		<cfset var classes = StructNew() />
	
		<cfif user.hasRole('Manager,HR Staff')>
			<cfset classes['Not Started'] = 'not_started' />
			<cfset classes['In Progress'] = 'in_progress' />
			<cfset classes['Late'] = 'late' />
			<cfset classes['At Risk'] = 'at_risk' />
			<cfset classes['Completed'] = 'completed' />
			<cfset classes['Canceled'] = 'canceled' />
		<cfelse>
			<cfset classes['Not Started'] = 'not_started' />
			<cfset classes['In Progress'] = 'in_progress' />
			<cfif this.phase.name EQ "Not Started">
				<cfset classes['Late'] = 'not_started' />
				<cfset classes['At Risk'] = 'not_started' />
			<cfelse>
				<cfset classes['Late'] = 'in_progress' />
				<cfset classes['At Risk'] = 'in_progress' />
			</cfif>
			<cfset classes['Completed'] = 'completed' />
			<cfset classes['Canceled'] = 'canceled' />
		</cfif>
		
		<cfif structKeyExists(classes, arguments.status)>
			<cfset return_value = classes[arguments.status] />
		</cfif>
			
		<cfreturn return_value  />
	</cffunction>
		
<!-------------------------------------------------------------------------------- isCollectiveProcess

	Description:
			
----------------------------------------------------------------------------------------------------->	

<cffunction name="isCollectiveProcess" access="public" returntype="boolean">
		<cfreturn this.collective EQ 1 />
	</cffunction>
	
<!---------------------------------------------------------------------------------------- hasDatesSet

	Description:	Returns true if all the activities for the position's staffing service delivery
								agreement have an estimated completion date filled in.
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="hasDatesSet" access="public"  returntype="boolean">
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT count(*) AS defined_activities
			FROM processes_staffing_activities
			WHERE process_id = 
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			AND est_completion_date IS NOT NULL
		</cfquery>
		
		<cfreturn query.defined_activities GT 0 />
	</cffunction>

<!--------------------------------------------------------------------------------------- getPositions

	Description:
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="getPositions" access="public"  returntype="supermodel.ObjectList">
		<cfset var positionService = createObject('component', 'hr_staffing.services.PositionService') />
		<cfset var position = createObject('component', 'hr_staffing.model.positions.position') />
		<cfset var gateway = createObject('component', 'hr_staffing.model.positions.PositionGateway') />
		<cfset var parameters = structNew() />
		<cfset parameters.process_id = this.id />
		<cfset position.init(variables.dsn) />
		<cfset gateway.init(variables.dsn) />
		<cfset positionService.init(position, gateway) />
		<cfreturn positionService.getList(parameters) />
	</cffunction>
	
<!---------------------------------------------------------------------------------------- getComments

	Description:	SELECTS from the comments_processes table to find comments for this position
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="getComments" access="public"  returntype="supermodel.ObjectList">
		<cfset var query = "" />
		<cfset var list = createObject('component', 'supermodel.ObjectList') />
		<cfset var object = createObject('component', 'hr_staffing.model.comments.Comment') />
		<cfset object.configure() />
		<cfset object.init(variables.dsn) />

		<cfquery name="query" datasource="#variables.dsn#">
			SELECT staffing_comments.*, staffing_users.login
			FROM staffing_comments
			JOIN comments_processes 
			  ON staffing_comments.id = comments_processes.comment_id
			JOIN staffing_users 
			  ON staffing_comments.user_id = staffing_users.id
			WHERE comments_processes.process_id =
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			ORDER BY date DESC
		</cfquery>
		
		<cfset list.init(
			object,
			query) />
		
		<cfreturn list />
	</cffunction>
	
<!----------------------------------------------------------------------------------------- addComment

	Description:	
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="addComment" access="public"  returntype="void">
		<cfargument name="comment" type="hr_staffing.model.comments.Comment" required="yes" />
		
		<cfquery datasource="#variables.dsn#">
			INSERT INTO comments_processes (
				comment_id, 
				process_id)
			VALUES (
				<cfqueryparam value="#arguments.comment.id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
			)
		</cfquery>
	</cffunction>

<!------------------------------------------------------------------------------------- getTransactions

	Description: Gets the entire history log for this position
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="getTransactions" access="public" returntype="supermodel.ObjectList">
		<cfset var query = "" />
		<cfset var object = createObject('component', 'hr_staffing.model.transactions.Transaction') />
		<cfset var list = createObject('component', 'supermodel.ObjectList') />
		
		<cfset object.init(variables.dsn) />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				transactions.old_value,
				transactions.new_value,
				transactions.[datetime],
				transactions.user_id,
				transactions.process_id,
				transactions.activity_id,
				transactions.action,
				(common_login..users.first_name + ' ' + common_login..users.last_name) as [user],
				staffing_activities.name as activity
			FROM transactions
			JOIN staffing_users 
				ON transactions.user_id = staffing_users.id
			JOIN staffing_activities
				ON transactions.activity_id = staffing_activities.id
			JOIN common_login..users
				ON staffing_users.login = common_login..users.login
			WHERE transactions.process_id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer">
			ORDER BY transactions.[datetime] DESC
		</cfquery>
		
		<cfset list.init(
			object,
			query) />
		
		<cfreturn list />
	</cffunction>

<!--------------------------------------------------------------------------------------- insertQuery

	Description:	Call the default insertQuery function from the DataModel to insert into position
								and then insert a record into processes_staffing_activities for each activity.
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="insertQuery" >
		<cfargument name="table" default="#variables.table_name#" />
		<cfargument name="fields" default="#variables.database_fields#" />
		
		<!--- Start a transaction so that if a problem occurs it won't cause data integrity problems --->
		<cftransaction action="begin">
		
			<cfquery name="getDefaults" datasource="#variables.dsn#">
				SELECT 
					statuses.id AS status_id,
					phases.id AS phase_id
				FROM statuses, phases
				WHERE statuses.name = 'Not Started'
				AND phases.name = 'Not Started'
			</cfquery>
			
			<cfset this.status_id = getDefaults.status_id />
			<cfset this.phase_id = getDefaults.phase_id />
		
			<!--- Call the Parent insertQuery to insert into the processes table --->
			<cfset Super.insertQuery(table, fields) />
			
			<!--- Create associated activity records --->
			<cfquery datasource="#variables.dsn#">
				DECLARE @status_id INT;
				DECLARE @endangered_time INT;
				
				SELECT @status_id = id FROM statuses 
				WHERE statuses.name = 'Not Started';
								
				INSERT INTO processes_staffing_activities (
					process_id, 
					activity_id,
					status_id,
					endangered_time
				)
				SELECT 
					#this.id#,
					staffing_activities.id,
					@status_id,
					staffing_activities.default_endangered_time
				FROM
					staffing_activities
				WHERE staffing_activities.id IN (
					SELECT activity_id
					FROM staffing_activities_staffing_methods
					WHERE staffing_activities_staffing_methods.staffing_method_id = 
						<cfqueryparam value="#this.staffing_method_id#" cfsqltype="cf_sql_integer" />
					);
			</cfquery>

		</cftransaction>
	</cffunction>	
	
<!--------------------------------------------------------------------------------------- canBeDeleted

	Description:	
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="canBeDeleted" access="public" returntype="boolean">
		<cfif hasPositions()>
			<cfset structInsert(variables.errors, 'positions', 'The process cannot be deleted because there are positions that reference it.  You must delete or update those positions first.') />
			<cfreturn false />
		</cfif>
		
		<cfreturn true />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- hasPositions

	Description:	
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="hasPositions" access="public" returntype="boolean">
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT count(*) AS num_positions
			FROM positions WHERE positions.process_id = 
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn query.num_positions NEQ 0>
	</cffunction>
</cfcomponent>