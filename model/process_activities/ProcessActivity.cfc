<cfcomponent displayname="ProcessActivity" extends="supermodel.DataModel">

<!------------------------------------------------------------------------------------------ configure

	Description:

----------------------------------------------------------------------------------------------------->

	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.table_name = "processes_staffing_activities" />

		<cfset belongsTo('process', 'hr_staffing.model.processes.Process') />
		<cfset belongsTo('activity', 'hr_staffing.model.activities.Activity') />
		<cfset belongsTo('status', 'hr_staffing.model.statuses.Status') />
	</cffunction>

<!------------------------------------------------------------------------------------------ getStatus

	Description:

----------------------------------------------------------------------------------------------------->

	<cffunction name="getStatus" access="public" returntype="string">
		<cfif this.status.name EQ "Completed">
			<cfreturn "Completed" />
		<cfelseif isDate(this.est_completion_date) AND DateCompare(DateFormat(Now(), "yyyy-mm-dd"), this.est_completion_date) EQ 1>
			<cfreturn "Late" />
		<cfelseif isDate(this.est_completion_date) AND DateCompare(DateFormat(DateAdd('d', this.endangered_time, Now()), "yyyy-mm-dd"), this.est_completion_date) EQ 1>
			<cfreturn "At Risk" />
		<cfelseif this.status.name EQ "In Progress">
			<cfreturn "In Progress" />
		</cfif>

		<cfreturn "Not Started" />
	</cffunction>

<!------------------------------------------------------------------------------------- getStatusClass

	Description:

----------------------------------------------------------------------------------------------------->

	<cffunction name="getStatusClass" access="public" returntype="string">
		<cfargument name="user" type="hr_staffing.model.users.User" required="yes" />
		<cfargument name="status" type="string" default="#getStatus()#" />

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
			<cfif this.status.name EQ "Not Started">
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

<!--------------------------------------------------------------------------------------- insertQuery

	Description:

----------------------------------------------------------------------------------------------------->

	<cffunction name="insertQuery" access="private" returntype="void">
		<cfargument name="table" default="#variables.table_name#" />
		<cfargument name="fields" default="#variables.database_fields#" />

		<cfquery name="getDefaults" datasource="#variables.dsn#">
			SELECT
				statuses.id AS status_id,
				staffing_activities.default_endangered_time as endangered_time
			FROM statuses, staffing_activities
			WHERE statuses.name = 'Not Started'
			AND staffing_activities.id = <cfqueryparam value="#this.activity_id#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfset this.status_id = getDefaults.status_id />
		<cfset this.endangered_time = getDefaults.endangered_time />

		<cfset super.insertQuery(arguments.table, arguments.fields) />
	</cffunction>
</cfcomponent>