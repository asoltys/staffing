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

		<cfset var pool = createObject('component', 'hr_staffing.model.pools.pool') />

		<cfset var classificationLevelService = getProperty('beanFactory').getBean('classificationLevelService') />
		<cfset var processService = getProperty('beanFactory').getBean('processService') />
		<cfset var userService = getProperty('beanFactory').getBean('userService') />

		<cfset var classification_levels = classificationLevelService.getList() />
		<cfset var processes = processService.getList() />
		<cfset var contacts = userService.getCurrentUsersList() />

    <cfset contacts.order('first_name') />

		<cfif event.isArgDefined('pool')>
			<cfset pool = event.getArg('pool') />
		<cfelse>
			<cfset pool.init(request.dsn) />

			<cfif event.isArgDefined('id') AND event.getArg('id') NEQ "">
				<cfset pool.read(event.getArg('id')) />
			</cfif>
		</cfif>

		<cfset event.setArg('pool', pool) />

		<cfset event.setArg('classification_levels', classification_levels) />
		<cfset event.setArg('processes', processes) />
		<cfset event.setArg('contacts', contacts) />
	</cffunction>

<!--------------------------------------------------------------------------------------- processForm

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="processForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var pool = createObject('component', 'hr_staffing.model.pools.pool') />
		<cfset pool.init(request.dsn) />

		<!--- If there is an id parameter then we update the object --->
		<cfif IsNumeric(arguments.event.getArg('id'))>
			<cfset pool.update(arguments.event.getArgs()) />
		<!--- otherwise we create a new one --->
		<cfelse>
			<cfset pool.create(arguments.event.getArgs()) />
		</cfif>

		<cfset arguments.event.setArg('pool', pool) />

		<!--- If the object is valid  --->
		<cfif pool.valid()>
				<cflocation url="#request.path#index.cfm?event=pools.list" addtoken="no" />
		<cfelse>
			<cfset event.setArg('errors', pool.getErrors()) />
			<cfset announceEvent('pools.form', arguments.event.getArgs()) />
		</cfif>
	</cffunction>

<!--------------------------------------------------------------------------------------- prepareList

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareList" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var poolService = getProperty('beanFactory').getBean('poolService') />
		<cfset var pools = poolService.getList() />
		<cfset var active_pools = "" />
		<cfset var expired_pools = "" />

		<cfset pools.order('process_number') />

		<cfif event.isArgDefined('process_id')>
			<cfset pools.filter('process_id = ' & event.getArg('process_id')) />
		</cfif>

		<cfset active_pools = pools.copy() />
		<cfset expired_pools = pools.copy() />
		<cfset active_pools.filter("expiry_date >= '#LSDateFormat(Now(), 'yyyy-mm-dd')#' or expiry_date is null") />
		<cfset expired_pools.filter("expiry_date < '#LSDateFormat(Now(), 'yyyy-mm-dd')#' and expiry_date is not null") />

		<cfset event.setArg('active_pools', active_pools) />
		<cfset event.setArg('expired_pools', expired_pools) />
	</cffunction>

<!-------------------------------------------------------------------------------------------- delete

	Description:

---------------------------------------------------------------------------------------------------->

	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var pool = createObject('component', 'hr_staffing.model.pools.pool') />

		<cfset pool.init(request.dsn) />
		<cfset pool.read(event.getArg('pool_id')) />

		<cfset pool.delete() />
		<cflocation url="#request.path#index.cfm?event=pools.list" addtoken="no" />
	</cffunction>
</cfcomponent>
