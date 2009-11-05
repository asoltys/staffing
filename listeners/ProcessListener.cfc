<cfcomponent extends="MachII.framework.Listener">

<!----------------------------------------------------------------------------------------- configure

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="configure" access="public" output="false" returntype="void"
			hint="Configures this listener as part of the Mach-II framework">
	</cffunction>

<!-------------------------------------------------------------------------------------- prepareForm

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var process = createObject('component', 'hr_staffing.model.processes.Process') />

		<cfset var staffingMethodService = getProperty('beanFactory').getBean('staffingMethodService') />
		<cfset var userService = getProperty('beanFactory').getBean('userService') />

		<cfset var board_chairs = userService.getCurrentUsersList() />
		<cfset var staffing_methods = staffingMethodService.getList() />

		<cfset board_chairs.order('first_name') />

		<cfif event.isArgDefined('process')>
			<cfset process = event.getArg('process') />
		<cfelse>
			<cfset process.init(request.dsn) />

			<cfif event.isArgDefined('id') AND event.getArg('id') NEQ "">
				<cfset process.read(event.getArg('id')) />
			</cfif>
		</cfif>

		<cfset event.setArg('process', process) />

		<cfset event.setArg('board_chairs', board_chairs) />
		<cfset event.setArg('staffing_methods', staffing_methods) />
	</cffunction>

<!--------------------------------------------------------------------------------------- processForm

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="processForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var process = createObject('component', 'hr_staffing.model.processes.Process') />
		<cfset process.init(request.dsn) />

		<cfif NOT event.isArgDefined('collective')>
			<cfset event.setArg('collective', 0) />
		</cfif>

		<!--- If there is an id parameter then we update the object --->
		<cfif IsNumeric(arguments.event.getArg('id'))>
			<cfset process.read(event.getArg('id')) />
			<cfset process.update(arguments.event.getArgs()) />
		<!--- otherwise we create a new one --->
		<cfelse>
			<cfset process.create(arguments.event.getArgs()) />
		</cfif>

		<cfset arguments.event.setArg('process', process) />

		<!--- If the position object is valid  --->
		<cfif process.valid()>
				<cflocation url="#request.path#index.cfm?event=processes.list" addtoken="no" />
		<cfelse>
			<cfset event.setArg('errors', process.getErrors()) />
			<cfset announceEvent('processes.form', arguments.event.getArgs()) />
		</cfif>
	</cffunction>

<!--------------------------------------------------------------------------------------- prepareList

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareList" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var processService = getProperty('beanFactory').getBean('processService') />
		<cfset var userService = getProperty('beanFactory').getBean('userService') />

		<cfset var processes = processService.getList() />
		<cfset var board_chairs = userService.getCurrentUsersList() />

		<cfif event.getArg('number') NEQ "">
			<cfset processes.filter("number = '#event.getArg('number')#'") />
		</cfif>

		<cfif event.getArg('board_chair_id') NEQ "">
			<cfset processes.filter("board_chair_id = #event.getArg('board_chair_id')#") />
		</cfif>

		<cfset event.setArg('processes', processes) />
		<cfset event.setArg('board_chairs', board_chairs) />
	</cffunction>

<!--------------------------------------------------------------------------------------- prepareSSDA

	Description:	Returns a query of all the entities

---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareSSDA" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var statusService = getProperty('beanFactory').getBean('statusService') />
		<cfset var process = createObject('component', 'hr_staffing.model.processes.Process') />
		<cfset var statuses = "" />
		<cfset var process_activities = "" />

		<cfset process.init(request.dsn) />
		<cfset process.read(event.getArg('process_id')) />
		<cfset process.readProcessActivities() />
		<cfset process.readComments() />
		<cfset process_activities = process.process_activities />
		<cfset process_activities.order('activity_sequence') />

		<cfset statuses = statusService.getList() />
		<cfset statuses.filter("activity_status = 1") />

		<cfset event.setArg('process', process) />
		<cfset event.setArg('process_activities', process_activities) />
		<cfset event.setArg('statuses', statuses) />
		<cfset event.setArg('comments', process.comments) />

		<cfset structInsert(session, 'return_url', CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING, true) />
	</cffunction>

<!--------------------------------------------------------------------------------------- updateSSDA

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="updateSSDA" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var process = createObject('component', 'hr_staffing.model.processes.Process') />
		<cfset var transaction = createObject('component', 'hr_staffing.model.transactions.Transaction') />
		<cfset var process_activities = "" />
		<cfset var activity = "" />

		<cfset var attributes = "status_id,completion_date,est_completion_date,endangered_time" />

		<cfset var old_value = "" />
		<cfset var new_value = "" />

		<cfset process.init(request.dsn) />
		<cfset transaction.init(request.dsn) />

		<cfset process.read(event.getArg('process_id')) />
		<cfset process.readProcessActivities() />

		<cfset process_activities = process.process_activities />

		<cfloop condition="#process_activities.next()#">
			<cfset process_activity = process_activities.current() />

			<cfloop list="#attributes#" index="attribute">
				<cfset old_value = process_activity[attribute] />
				<cfset new_value = event.getArg(attribute & '_' & process_activity.id) />

				<cfif isDate(old_value) AND isDate(new_value)>
					<cfset old_value = LSDateFormat(old_value, "yyyy-mm-dd") />
					<cfset new_value = LSDateFormat(new_value, "yyyy-mm-dd") />
				</cfif>

				<cfif old_value NEQ new_value>
					<cfset transaction.action = attribute />
					<cfset transaction.process_activity_id = process_activity.id />
					<cfset transaction.old_value = old_value />
					<cfset transaction.new_value = new_value />
					<cfset transaction.user_id = request.current_user.id />
					<cfset transaction.datetime = Now() />
					<cfset transaction.save() />
					<cfset transaction.id = "" />
					<cfset process_activity[attribute] = new_value />
				</cfif>
			</cfloop>

			<cfif NOT isDate(process_activity.est_completion_date)>
				<cfset process_activity.est_completion_date = "" />
			</cfif>

			<cfif NOT isDate(process_activity.completion_date)>
				<cfset process_activity.completion_date = "" />
			</cfif>

			<cfset process_activity.save() />
		</cfloop>

    <cfstoredproc procedure="UpdateProcesses" datasource="#request.dsn#" />
		<cflocation url="#request.path#index.cfm?event=processes.ssda&process_id=#process.id#" addtoken="no" />
	</cffunction>

<!------------------------------------------------------------------------------------- deleteProcess

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="deleteProcess" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var process = createObject('component', 'hr_staffing.model.processes.Process') />

		<cfset process.init(request.dsn) />
		<cfset process.read(event.getArg('process_id')) />

		<cfif process.canBeDeleted()>
			<cfset process.delete() />
			<cflocation url="#request.path#index.cfm?event=processes.list" addtoken="no" />
		<cfelse>
			<cfset event.setArg('errors', process.getErrors()) />
			<cfset announceEvent('processes.list', arguments.event.getArgs()) />
		</cfif>
	</cffunction>

<!-------------------------------------------------------------------------------------- addActivity

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="addActivity" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var process_activity = createObject('component', 'hr_staffing.model.process_activities.ProcessActivity') />

		<cfset process_activity.init(request.dsn) />
		<cfset process_activity.activity_id = event.getArg('activity_id') />
		<cfset process_activity.process_id = event.getArg('process_id') />
		<cfset process_activity.create() />

		<cflocation url="#request.path#index.cfm?event=processes.ssda&process_id=#event.getArg('process_id')#" addtoken="no" />
	</cffunction>

<!------------------------------------------------------------------------------------ deleteActivity

	Description:	Called via AJAX request.  This function deletes a process_activity.  This can be
								used to remove activities from a position when they are not applicable to the
								position.

---------------------------------------------------------------------------------------------------->

	<cffunction name="deleteActivity" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var process_activity = createObject('component', 'hr_staffing.model.process_activities.ProcessActivity') />
		<cfset var response_structure = StructNew() />

		<cfset process_activity.init(request.dsn) />
		<cfset process_activity.read(event.getArg('process_activity_id')) />
		<cfset process_activity.delete() />
		<cfset response_structure.process_activity_id = event.getArg('process_activity_id') />
		<cfset event.setArg('response_structure', response_structure) />
	</cffunction>

<!---------------------------------------------------------------------------------------- addComment

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="addComment" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var process = createObject('component', 'hr_staffing.model.processes.Process') />
		<cfset var comment = createObject('component', 'hr_staffing.model.comments.Comment') />

		<cfset process.init(request.dsn) />
		<cfset comment.init(request.dsn) />

		<cfset process.read(event.getArg('process_id')) />
		<cfset comment.create(event.getArgs()) />

		<cfset process.addComment(comment) />

		<cfset announceEvent('processes.ssda', event.getArgs()) />
	</cffunction>

<!------------------------------------------------------------------------------------- removeComment

	Description:	Returns a query of all the entities

---------------------------------------------------------------------------------------------------->

	<cffunction name="removeComment" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var comment = createObject('component', 'hr_staffing.model.comments.Comment') />
		<cfset comment.init(request.dsn) />
		<cfset comment.read(event.getArg('comment_id')) />
		<cfset comment.delete() />

		<cfset announceEvent('processes.ssda', event.getArgs()) />
	</cffunction>
</cfcomponent>
