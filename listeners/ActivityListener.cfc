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

		<cfset var activity = createObject('component', 'hr_staffing.model.activities.activity') />
		<cfset var phaseService = getProperty('beanFactory').getBean('phaseService') />
		
		<cfset var phases = phaseService.getList() />
		
		<cfif event.isArgDefined('activity')>
			<cfset activity = event.getArg('activity') />
		<cfelse>
			<cfset activity.init(request.dsn) />
			
			<cfif event.isArgDefined('id') AND event.getArg('id') NEQ "">
				<cfset activity.read(event.getArg('id')) />
			</cfif>
		</cfif>
		
		<cfset event.setArg('activity', activity) />
		<cfset event.setArg('phases', phases) />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- processForm

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="processForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var activity = createObject('component', 'hr_staffing.model.activities.activity') />
		<cfset var return_url = session['return_url'] />
		<cfset structDelete(session, 'return_url') />
		
		<cfset activity.init(request.dsn) />
		<cfset activity.save(arguments.event.getArgs()) />
		<cfset arguments.event.setArg('activity', activity) />
		
		<!--- If the position object is valid  --->
		<cfif activity.valid()>
			<cflocation url="#return_url#" addtoken="no" />
		<cfelse>
			<cfset event.setArg('errors', activity.getErrors()) />
			<cfset announceEvent('activities.form', arguments.event.getArgs()) />
		</cfif>		
	</cffunction>
</cfcomponent>
