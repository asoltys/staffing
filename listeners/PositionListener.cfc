<cfcomponent extends="MachII.framework.Listener">
		
<!----------------------------------------------------------------------------------------- configure

	Description:	Create an empty struct to hold all the position objects for the application
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="configure" access="public" output="false" returntype="void" 
			hint="Configures this listener as part of the Mach-II framework">
	</cffunction>
	
<!------------------------------------------------------------------------------------ deletePosition

	Description:	Deletes the given position
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="deletePosition" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var position = createObject('component', 'hr_staffing.model.positions.position') />
		
		<cfset position.init(request.dsn) />
		<cfset position.read(event.getArg('id')) />
		<cfset position.delete() />
				
		<cflocation url="#request.path#index.cfm?event=positions.staffing_log" addtoken="no" />
	</cffunction>
	
<!-------------------------------------------------------------------------------------- prepareForm

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var position = createObject('component', 'hr_staffing.model.positions.position') />
		
		<cfset var jobService = getProperty('beanFactory').getBean('jobService') />
		<cfset var languageConsiderationService = getProperty('beanFactory').getBean('languageConsiderationService') />
		<cfset var locationService = getProperty('beanFactory').getBean('locationService') />
		<cfset var processService = getProperty('beanFactory').getBean('processService') />
		<cfset var positionService = getProperty('beanFactory').getBean('positionService') />
		<cfset var securityLevelService = getProperty('beanFactory').getBean('securityLevelService') />
		<cfset var tenureService = getProperty('beanFactory').getBean('tenureService') />
		<cfset var userService = getProperty('beanFactory').getBean('userService') />
		
		<cfset var language_considerations = languageConsiderationService.getList() />
		<cfset var locations = locationService.getList() />
		<cfset var managers = userService.getCurrentUsersList() />
		<cfset var titles = jobService.getExistingJobTitles() />
		<cfset var processes = processService.getList() />
		<cfset var security_levels = securityLevelService.getList() />
		<cfset var tenures = tenureService.getList() />
			
		<cfif event.isArgDefined('position')>
			<cfset position = event.getArg('position') />
		<cfelse>
			<cfset position.init(request.dsn) />
			
			<cfif event.isArgDefined('id') AND event.getArg('id') NEQ "">
				<cfset position.read(event.getArg('id')) />
			</cfif>
		</cfif>
		
		<cfset managers.order('first_name, last_name') />

		<cfset event.setArg('language_considerations',language_considerations) />
		<cfset event.setArg('locations', locations) />
		<cfset event.setArg('managers', managers) />
		<cfset event.setArg('titles', titles) />
		<cfset event.setArg('processes', processes) />
		<cfset event.setArg('position', position) />
		<cfset event.setArg('security_levels', security_levels) />
		<cfset event.setArg('tenures', tenures) />
	</cffunction>
	
<!-------------------------------------------------------------------------------------- prepareList

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareList" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var userService = getProperty('beanFactory').getBean('userService') />
		<cfset var staffers = userService.getUsersByRole('HR Staff') />
		<cfset event.setArg('staffers', staffers) />
	</cffunction>
	
<!----------------------------------------------------------------------------- prepareNightlyRoutine

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareNightlyRoutine" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var userService = getProperty('beanFactory').getBean('userService') />
		<cfset var staffers = userService.getUsersByRole('HR Staff') />
		<cfset var staffer = createObject('component', 'hr_staffing.model.users.staffer') />
		<cfset staffer.init(request.dsn) />
		<cfset staffers.setObject(staffer) />
		<cfset event.setArg('staffers', staffers) />
	</cffunction>
	
<!-------------------------------------------------------------------------------- prepareStaffingLog

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareStaffingLog" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		

		<cfset var branchService = getProperty('beanFactory').getBean('branchService') />
		<cfset var classificationService = getProperty('beanFactory').getBean('classificationService') />
		<cfset var locationService = getProperty('beanFactory').getBean('locationService') />
		<cfset var phaseService = getProperty('beanFactory').getBean('phaseService') />
		<cfset var positionService = getProperty('beanFactory').getBean('positionService') />
		<cfset var securityLevelService = getProperty('beanFactory').getBean('securityLevelService') />
		<cfset var staffingMethodService = getProperty('beanFactory').getBean('staffingMethodService') />
		<cfset var statusService = getProperty('beanFactory').getBean('statusService') />
		<cfset var tenureService = getProperty('beanFactory').getBean('tenureService') />

		<cfset var branches = branchService.getList() />
		<cfset var classifications = classificationService.getList() />
		<cfset var locations = locationService.getList() />
		<cfset var phases = phaseService.getList() />
		<cfset var security_levels = securityLevelService.getList() />
		<cfset var staffing_methods = staffingMethodService.getList() />
		<cfset var statuses = statusService.getList() />
		<cfset var tenures = tenureService.getList() />

		<cfset var groupings = structNew() />
		<cfset var orderings = structNew() />
		<cfset var position_order = event.getArg('order_by') />

    <cfif event.isArgDefined('refresh')>
      <cfset structDelete(session, 'params')>
    </cfif>

    <cfif structKeyExists(session, 'params') 
      and not event.isArgDefined('search') 
      and not event.isArgDefined('user_id')>
      <cfset event.setArgs(session['params']) />
    </cfif>

    <cfif not event.isArgDefined('fiscal_year')>
      <cfset event.setArg('fiscal_year', year(dateadd('m', -3, now()))) />
    </cfif>

    <cfset positions = positionService.getList(event.getArgs()) />
    <cfset positions_query = positions.toQuery() />
    <cfset session['params'] = structCopy(event.getArgs()) />
		<cfset groupings['manager_id'] = "manager_name" />
		<cfset groupings['branch_acronym'] = 'branch_name' />
		<cfset groupings['fiscal_year'] = 'fiscal_year' />
		<cfset groupings['process_id'] = 'process_number' />
		
		<cfset orderings['Title'] = 'job_title' />
		<cfset orderings['Position Number'] = 'number' />
		<cfset orderings['Group / Level'] = 'classification_name, classification_level_name' />
		<cfset orderings['Manager'] = 'manager_name' />
		<cfset orderings['Phase'] = 'phase_name' />
		<cfset orderings['Branch'] = 'branch_name' />
		<cfset orderings['Year'] = 'fiscal_year' />
		
		<cfif request.current_user.hasRole('HR Staff,Manager')>
			<cfset orderings['Status'] = 'status_name' />
		</cfif>
		
		<cfif NOT event.isArgDefined('group_by')>
			<cfset event.setArg('group_by', 'branch_acronym') />
		</cfif>
		
		<cfset group_value_col = event.getArg('group_by') />
		<cfset group_display_col = groupings[group_value_col] />

		<cfquery name="groups" dbtype="query">
			SELECT DISTINCT 
				#group_value_col#, 
				#group_display_col#
			FROM positions_query
			ORDER BY #group_display_col#
		</cfquery>
				
		<cfif position_order EQ "" OR event.getArg('order_by') EQ 'classification_name, classification_level_name'>
			<cfset position_order = 'classification_name ' & event.getArg('direction') & ', classification_level_name' />
		</cfif>
				
		<cfset branches.order('name') />
		<cfset classifications.order('name') />
		<cfset locations.order('name') />
		<cfset positions.order(position_order, event.getArg('direction')) />
		<cfset phases.order('name') />
		<cfset staffing_methods.order('name') />
		<cfset security_levels.order('name') />
		<cfset statuses.order('name') />
		<cfset tenures.order('name') />
		
		<cfif not event.getArg('direction') EQ 'DESC'>
			<cfset event.setArg('direction', 'DESC') />
		<cfelse>
			<cfset event.setArg('direction', 'ASC') />
		</cfif>

		<cfset event.setArg('group_display_col', group_display_col) />
		<cfset event.setArg('groups', groups) />
		<cfset event.setArg('orderings', orderings) />
		
		<cfset event.setArg('branches', branches) />
		<cfset event.setArg('classifications', classifications) />
		<cfset event.setArg('locations', locations) />
		<cfset event.setArg('positions', positions) />
		<cfset event.setArg('phases', phases) />
		<cfset event.setArg('staffing_methods', staffing_methods) />
		<cfset event.setArg('security_levels', security_levels) />
		<cfset event.setArg('statuses', statuses) />
		<cfset event.setArg('tenures', tenures) />
	</cffunction>
	
<!---------------------------------------------------------------------------- prepareStaffingArchive

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareStaffingArchive" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfif event.isArgDefined('fiscal_year')>
			<cfset prepareStaffingLog(event) />
		</cfif>
	</cffunction>
	
<!------------------------------------------------------------------------------------- addAssignees

	Description:	
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="addAssignees" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var position = createObject('component', 'hr_staffing.model.positions.position') />
		<cfset position.init(request.dsn) />
		<cfset position.read(event.getArg('id')) />
		<cfset position.addAssignees(event.getArg('assignees')) />
		<cfset announceEvent('positions.form', event.getArgs()) />
	</cffunction>
		
<!--------------------------------------------------------------------------------------- processForm

	Description:	Validate the form then either create or update the position.
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="processForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var position = createObject('component', 'hr_staffing.model.positions.position') />
		<cfset position.init(request.dsn) />

		<cfif NOT event.isArgDefined('infrastructure')>
			<cfset event.setArg('infrastructure', 0) />
		</cfif>
    
    <!--- If there is an id parameter then we update the object --->
		<cfif IsNumeric(arguments.event.getArg('id'))>
			<cfset position.update(arguments.event.getArgs()) />
		<!--- otherwise we create a new one --->
		<cfelse>
			<cfset position.create(arguments.event.getArgs()) />
		</cfif>
		
		<cfset arguments.event.setArg('position', position) />
		
		<!--- If the position object is valid  --->
		<cfif position.valid()>
			<cfif IsNumeric(arguments.event.getArg('id'))>
				<cflocation url="#request.path#index.cfm?event=positions.staffing_log&branch=#position.job.branch#" addtoken="no" />
			<cfelse>
				<cfset position.addAssignees(request.current_user.id) />
				<cfset announceEvent('positions.created', arguments.event.getArgs()) />
			</cfif>
		<cfelse>
			<cfset event.setArg('errors', position.getErrors()) />
			<cfset announceEvent('positions.form', arguments.event.getArgs()) />
		</cfif>		
	</cffunction>
	
<!----------------------------------------------------------------------------- prepareSetProcessForm

	Description:	Validate the form then either create or update the position.
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareSetProcessForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var processService = getProperty('beanFactory').getBean('processService') />
		<cfset var userService = getProperty('beanFactory').getBean('userService') />
		<cfset var staffingMethodService = getProperty('beanFactory').getBean('staffingMethodService') />
		
		<cfset var position = createObject('component', 'hr_staffing.model.positions.position') />
		<cfset var process = createObject('component', 'hr_staffing.model.processes.process') />
		<cfset var processes = processService.getList() />
		<cfset var board_chairs = userService.getCurrentUsersList() />
		<cfset var staffing_methods = staffingMethodService.getList() />
		
		<cfset position.init(request.dsn) />
		<cfset position.read(event.getArg('position_id')) />
		
		<cfset board_chairs.order('first_name') />
		
		<cfif event.isArgDefined('process')>
			<cfset process = event.getArg('process') />
		<cfelse>
			<cfset process.init(request.dsn) />
			
			<cfif event.isArgDefined('process_id') AND event.getArg('process_id') NEQ "">
				<cfset process.read(event.getArg('process_id')) />
			</cfif>
		</cfif>
		
		<cfset processes.order('number ASC') />
		
		<cfset event.setArg('position', position) />
		<cfset event.setArg('process', process) />
		<cfset event.setArg('processes', processes) />
		<cfset event.setArg('board_chairs', board_chairs) />
		<cfset event.setArg('staffing_methods', staffing_methods) />
	</cffunction>
	
<!------------------------------------------------------------------------------------- createProcess

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="createProcess" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var position = createObject('component', 'hr_staffing.model.positions.position') />
		<cfset var process = createObject('component', 'hr_staffing.model.processes.process') />

    <cfif not event.isArgDefined('collective')>
		  <cfset event.setArg('collective', '0') />
    </cfif>
		
		<cfset position.init(request.dsn) />
		<cfset process.init(request.dsn) />
		
		<cfset process.create(event.getArgs()) />
		
		<cfif process.valid()>
			<cfset position.read(event.getArg('position_id')) />
			<cfset position.process_id = process.id />
			<cfset position.save() />
			<cflocation url="#request.path#index.cfm?event=processes.ssda&process_id=#position.process_id#" addtoken="no" />
		<cfelse>
			<cfset event.setArg('errors', process.getErrors()) />
			<cfset announceEvent('positions.set_process', arguments.event.getArgs()) />
		</cfif>
	</cffunction>
	
<!------------------------------------------------------------------------------------- updateProcess

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="updateProcess" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var position = createObject('component', 'hr_staffing.model.positions.position') />
		<cfset position.init(request.dsn) />
		<cfset position.read(event.getArg('id')) />
		<cfset position.process_id = event.getArg('process_id') />
		<cfset position.save() />
		<cflocation url="#request.path#index.cfm?event=processes.ssda&process_id=#position.process_id#" addtoken="no" />
	</cffunction>
	
<!-------------------------------------------------------------------------------------- getPositions

	Description:	Return a query object of all positions in the database
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="getPositions" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn gateway.select() />
	</cffunction>
	
<!------------------------------------------------------------------------------------- getHistory

	Description:	Return a query object of all history logs 
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="getHistory" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset position.read(event.getArg('id')) />
		<cfreturn position.getHistory() />
	</cffunction>
	
<!------------------------------------------------------------------------------------- getStatuses

	Description:	Return a query object of all statuses in the table
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="getStatuses" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn gateway.getStatuses() />
	</cffunction>

	
<!------------------------------------------------------------------------------------- getBranchCount

	Description:	Return a query object of Position Activity counts by Branches
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="getBranchCount" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn gateway.getBranchCount() />
	</cffunction>
	
<!------------------------------------------------------------------------------------- getPhaseActCount

	Description:	Return a query object of Position Activity counts by Phases and Activities
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="getPhaseActCount" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn gateway.getPhaseActCount() />
	</cffunction>
	
<!------------------------------------------------------------------------------------- getHRAssistants

	Description:	Return a query object of all hr assistants in database
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="getHRAssistants" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn gateway.getHRAssistants() />
	</cffunction>
	
<!-------------------------------------------------------------------------------- processAssignments

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="processAssignments" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var positions = event.getArg('positions') />
		<cfset var users = event.getArg('users') />
		
		<cfset positions = Left(positions, Len(positions) - 1) />
		
		<cfquery datasource="#request.dsn#">
			DELETE FROM positions_users
			WHERE position_id IN (
				<cfqueryparam value="#positions#" list="yes" />
			)
			AND user_id IN (
				<cfqueryparam value="#users#" list="yes" />
			)
		</cfquery>
		
		<cfif event.getArg('action') EQ 'assign'>
			<cfquery datasource="#request.dsn#">
				INSERT INTO positions_users (position_id, user_id)
				(
					SELECT positions.id, staffing_users.id
					FROM positions, staffing_users
					WHERE positions.id IN (
						<cfqueryparam value="#positions#" list="yes" />
					)
					AND staffing_users.id IN (
						<cfqueryparam value="#users#" list="yes" />
					)
				)
			</cfquery>
		</cfif>
		
		<cflocation url="#request.path#index.cfm?event=positions.staffing_log" addtoken="no" />
	</cffunction>
	
<!--------------------------------------------------------------------------- getClassificationLevels

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="getClassificationLevels">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var classification_id = event.getArg('classification_id') />
		<cfset var query = "" />
		
		<cfif classification_id EQ "">
			<cfset classification_id = 0 />
		</cfif>
		
		<cfquery name="query" datasource="#request.dsn#">
			SELECT DISTINCT
				classification_levels.id,
				classification_levels.name
			FROM
			classification_levels
			JOIN classifications 
				ON classifications.id = classification_levels.classification_id
			WHERE classifications.id = 
				<cfqueryparam value="#classification_id#" cfsqltype="cf_sql_integer" />
			ORDER BY classification_levels.name
		</cfquery>
		
		<cfset event.setArg('response_structure', query) />
	</cffunction>

</cfcomponent>
