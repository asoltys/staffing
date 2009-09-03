<cfcomponent extends="MachII.framework.Listener">
		
<!----------------------------------------------------------------------------------------- configure

	Description:	
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="configure" access="public" output="false" returntype="void" 
		hint="Configures this listener as part of the Mach-II framework">
		
		<cfset variables.service = createObject('component', 'hr_staffing.services.locationService') />

  </cffunction>
	
<!-------------------------------------------------------------------------------------- prepareForm

	Description:	Puts an object in the event
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />		
		<cfset var location = createObject('component', 'hr_staffing.model.locations.location') />
		
		<cfset var regionService = getProperty('beanFactory').getBean('regionService') />

		<cfset var regions = regionService.getList() />		
		<cfset regions.order('name') />
		
		<cfif event.isArgDefined('location')>
			<cfset location = event.getArg('location') />
		<cfelse>
			<cfset location.init(request.dsn) />
			<cfif event.isArgDefined('id') AND event.getArg('id') NEQ "">
				<cfset location.read(event.getArg('id')) />
			</cfif>
		</cfif>

		<cfset event.setArg('regions',regions) />				
		<cfset event.setArg('location', location) />
	</cffunction>

<!--------------------------------------------------------------------------------------- prepareList

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareList" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var locationService = getProperty('beanFactory').getBean('locationService') />
		<cfset var locations = locationService.getList() />		
		<cfset event.setArg('locations', locations) />		
	</cffunction>
	
<!--------------------------------------------------------------------------------------- processForm

	Description:	Validate the form then either create or update the object.
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="processForm" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var location = createObject('component', 'hr_staffing.model.locations.location') />
		<cfset location.init(request.dsn) />
		
    <cfset location.load(arguments.event.getArgs()) />		
		<cfset arguments.event.setArg('location', location) />
		
		<cfif location.valid()>
			<cfset location.save() />
			<cfif event.getArg('id') eq ''>
				<cflocation url="#request.path#index.cfm?event=locations.list" addtoken="no" />
			<cfelse>
				<cflocation url="#request.path#index.cfm?event=locations.list" addtoken="no" />
			</cfif>
		<cfelse>
			<cfset event.setArg('errors', location.getErrors()) />
			<cfset announceEvent('locations.form', arguments.event.getArgs()) />
		</cfif>
	</cffunction>
</cfcomponent>
