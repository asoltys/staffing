<cfcomponent displayname="Position" extends="supermodel.DataModel" hint="A staffing position.">
	<cffunction name="configure" access="public" returntype="void" >
		<cfset variables.table_name = 'positions' />

    <cfset addProperty('id', 'int') />
    <cfset addProperty('job_id', 'int') />
    <cfset addProperty('security_level_id', 'int') />
    <cfset addProperty('tenure_id', 'int') />
    <cfset addProperty('process_id', 'int') />
    <cfset addProperty('manager_id', 'int') />
    <cfset addProperty('language_consideration_id', 'int') />
    <cfset addProperty('number', 'varchar') />
    <cfset addProperty('rationale', 'text') />
    <cfset addProperty('comments', 'text') />
    <cfset addProperty('fiscal_year', 'char') />
    <cfset addProperty('location', 'varchar') />
    <cfset addProperty('infrastructure', 'bit') />

    <cfset this.fiscal_year = year(now()) />
		
		<cfset belongsTo('language_consideration', 'hr_staffing.model.language_considerations.LanguageConsideration') />
		<cfset belongsTo('job', 'hr_staffing.model.jobs.Job') />
		<cfset belongsTo('process', 'hr_staffing.model.processes.Process') />
		<cfset belongsTo('manager', 'hr_staffing.model.users.manager') />
		<cfset belongsTo('tenure', 'hr_staffing.model.tenures.Tenure') />
		<cfset belongsTo('security_level', 'hr_staffing.model.security_levels.SecurityLevel') />
		<cfset hasMany('assignees', 'hr_staffing.model.users.User', 'assignee') />
	</cffunction>

<!---------------------------------------------------------------------------------------------- phase

	Description:	
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="phase" access="public"  returntype="string">
		<cfif hasProcess()>
			<cfreturn this.process.phase.name />
		<cfelse>
			<cfreturn 'Not Started' />
		</cfif>
	</cffunction>
		
<!----------------------------------------------------------------------------------------- hasProcess

	Description:	
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="hasProcess" access="public"  returntype="boolean">
		<cfreturn this.process_id NEQ "" />
	</cffunction>


<!---------------------------------------------------------------------------------- forInfrastructure 

	Description:	
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="forInfrastructure" access="public"  returntype="string">
    <cfif this.infrastructure EQ "1">
      <cfreturn "Yes" />
    <cfelse>
      <cfreturn "No" />
    </cfif>
	</cffunction>


<!-------------------------------------------------------------------------------------- readAssignees

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="readAssignees" access="public" returntype="void">
		<cfset var query = "" />
			
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				common_login..users.email as assignee_email,
				common_login..users.first_name assignee_first_name,
				common_login..users.last_name assignee_last_name
			FROM positions
			JOIN positions_users ON positions.id = positions_users.position_id
			JOIN staffing_users ON positions_users.user_id = staffing_users.id
			JOIN common_login..users ON common_login..users.login = staffing_users.login
			WHERE positions.id = <cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset this.assignees.setQuery(query) />
	</cffunction>
	
	
<!-------------------------------------------------------------------------------- getCurrentAssignees

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getCurrentAssignees" access="public" returntype="supermodel.ObjectList">
		<cfset var userGateway = createObject('component', 'hr_staffing.model.users.userGateway') />
		<cfset var query = "" />
		<cfset var list = createObject('component', 'supermodel.ObjectList') />
		<cfset var object = createObject('component', 'hr_staffing.model.users.User') />

		<cfset object.init(variables.dsn) />

		<cfset userGateway.init(variables.dsn) />
		
		<cfset query = userGateway.select(
			conditions = "staffing_users.id IN (SELECT user_id FROM positions_users WHERE position_id = '#this.id#')") />
		
		<cfset list.init(
			object,
			query) />
		
		<cfreturn list />
	</cffunction>
	
<!------------------------------------------------------------------------------ getPotentialAssignees

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="getPotentialAssignees" access="public" returntype="supermodel.ObjectList">
		<cfset var userGateway = createObject('component', 'hr_staffing.model.users.userGateway') />
		<cfset var query = "" />
		<cfset var list = createObject('component', 'supermodel.ObjectList') />
		<cfset var object = createObject('component', 'hr_staffing.model.users.User') />

		<cfset object.init(variables.dsn) />
		
		<cfset userGateway.init(variables.dsn) />
		
		<cfset query = userGateway.select(
			conditions = "staffing_users.id NOT IN (
			SELECT user_id 
			FROM positions_users 
			WHERE position_id = '#this.id#')
			AND common_login..roles.name = 'HR Staff'") />
	
		<cfset list.init(
			object,
			query) />
		
		<cfreturn list />
	</cffunction>
	
<!-------------------------------------------------------------------------------------- addAssignees

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="addAssignees" access="public" returntype="void">
		<cfargument name="assignees" type="string" required="yes" />
		
		<cfloop list="#arguments.assignees#" index="assignee_id">
			<cfquery datasource="#variables.dsn#">
				INSERT INTO positions_users (
					position_id, 
					user_id
				)
				VALUES (
					<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#assignee_id#" cfsqltype="cf_sql_integer" />
				)
			</cfquery>
		</cfloop>
	</cffunction>
</cfcomponent>
