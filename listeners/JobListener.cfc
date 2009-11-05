<cfcomponent extends="MachII.framework.Listener">
		
<!----------------------------------------------------------------------------------------- configure

	Description:	
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="configure" access="public" output="false" returntype="void" 
		hint="Configures this listener as part of the Mach-II framework">
		
		<cfset variables.service = createObject('component', 'hr_staffing.services.JobService') />

  </cffunction>
	
<!-------------------------------------------------------------------------------------- prepareForm

	Description:	Puts an object in the event
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />		
		<cfset var job = createObject('component', 'hr_staffing.model.jobs.Job') />
		
		<cfset var classificationService = getProperty('beanFactory').getBean('classificationService') />
		<cfset var classificationLevelService = getProperty('beanFactory').getBean('classificationLevelService') />
		<cfset var branchService = getProperty('beanFactory').getBean('branchService') />

		<cfset var branches = branchService.getList() />		
		<cfset var classifications = classificationService.getList() />
		<cfset var classification_levels = classificationLevelService.getList() />	
		
		<cfif event.isArgDefined('job')>
			<cfset job = event.getArg('job') />
		<cfelse>
			<cfset job.init(request.dsn) />
			<cfif event.isArgDefined('id') AND event.getArg('id') NEQ "">
				<cfset job.read(event.getArg('id')) />
			</cfif>
		</cfif>
		
		<cfset event.setArg('job', job) />
		
		<cfset branches.order('name') />

		<cfset event.setArg('branches',branches) />				
		<cfset event.setArg('classification_levels',classification_levels) />
		<cfset event.setArg('classifications', classifications) />
	</cffunction>

<!--------------------------------------------------------------------------------------- prepareList

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareList" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var branchService = getProperty('beanFactory').getBean('branchService') />
		<cfset var jobService = getProperty('beanFactory').getBean('jobService') />
		<cfset var classificationLevelService = getProperty('beanFactory').getBean('classificationLevelService') />

		
		<cfset var branches = branchService.getList() />		
		<cfset var classification_levels = classificationLevelService.getList() />	
		<cfset var jobs = jobService.getList() />		

		<cfset event.setArg('branches', branches) />
		<cfset event.setArg('classification_levels', classification_levels) />
		<cfset event.setArg('jobs', jobs) />		
	</cffunction>
	
<!--------------------------------------------------------------------------------------- processForm

	Description:	Validate the form then either create or update the object.
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="processForm" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var job = createObject('component', 'hr_staffing.model.jobs.Job') />
		<cfset job.init(request.dsn) />
		
    <cfset job.load(arguments.event.getArgs()) />		
		<cfset arguments.event.setArg('job', job) />
		
		<cfif job.valid()>
			<cfset job.save() />
			<cfif event.getArg('id') eq ''>
				<cflocation url="#request.path#index.cfm?event=jobs.list" addtoken="no" />
			<cfelse>
				<cflocation url="#request.path#index.cfm?event=jobs.list" addtoken="no" />
			</cfif>
		<cfelse>
			<cfset event.setArg('errors', job.getErrors()) />
			<cfset announceEvent('jobs.form', arguments.event.getArgs()) />
		</cfif>
	</cffunction>
	
<!------------------------------------------------------------------------------------- processDelete

	Description:	Delete the object
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="processDelete" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var job = createObject('component', 'hr_staffing.model.jobs.Job') />
		<cfset job.init(request.dsn) />
		
    	<cfset job.load(arguments.event.getArgs()) />
		
		<cfif job.canBeDeleted()>
			<cfset job.delete() />
			<cflocation url="#request.path#index.cfm?event=jobs.list" addtoken="no" />
		<cfelse>
			<cfset event.setArg('errors', job.getErrors()) />
			<cfset announceEvent('jobs.list', arguments.event.getArgs()) />
		</cfif>
	</cffunction>
	
<!-------------------------------------------------------------------------------- getClassifications

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="getClassifications">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var title = event.getArg('title') />
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#request.dsn#">
			SELECT DISTINCT 
				classifications.name
			FROM jobs
			JOIN classification_levels 
				ON jobs.classification_level_id = classification_levels.id
			JOIN classifications 
				ON classification_levels.classification_id = classifications.id
			WHERE jobs.title = <cfqueryparam value="#title#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfset event.setArg('response_structure', query) />
	</cffunction>
	
<!--------------------------------------------------------------------------- getClassificationLevels

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="getClassificationLevels">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var classification = event.getArg('classification') />
		<cfset var title = event.getArg('title') />
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#request.dsn#">
			SELECT DISTINCT
				classification_levels.name
			FROM jobs
			JOIN classification_levels
				ON jobs.classification_level_id = classification_levels.id
			JOIN classifications 
				ON classifications.id = classification_levels.classification_id
			WHERE jobs.title = 
				<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar" />
			AND classifications.name = 
				<cfqueryparam value="#classification#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfset event.setArg('response_structure', query) />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- getBranches

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="getBranches">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var title = event.getArg('title') />
		<cfset var classification = event.getArg('classification') />
		<cfset var classification_level = event.getArg('classification_level') />
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#request.dsn#">
			SELECT DISTINCT 
				jobs.branch
			FROM jobs
			JOIN classification_levels 
				ON jobs.classification_level_id = classification_levels.id
			JOIN classifications 
				ON classification_levels.classification_id = classifications.id
			WHERE jobs.title = 
				<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar" />
			AND classifications.name = 
				<cfqueryparam value="#classification#" cfsqltype="cf_sql_varchar" />
			AND classification_levels.name = 
				<cfqueryparam value="#classification_level#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfset event.setArg('response_structure', query) />
	</cffunction>
	
<!-------------------------------------------------------------------------------------- getLocations

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="getLocations">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var title = event.getArg('title') />
		<cfset var classification = event.getArg('classification') />
		<cfset var classification_level = event.getArg('classification_level') />
		<cfset var branch = event.getArg('branch') />
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#request.dsn#">
			SELECT DISTINCT 
				jobs.location
			FROM jobs
			JOIN classification_levels 
				ON jobs.classification_level_id = classification_levels.id
			JOIN classifications 
				ON classification_levels.classification_id = classifications.id
			WHERE jobs.title = 
				<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar" />
			AND classifications.name = 
				<cfqueryparam value="#classification#" cfsqltype="cf_sql_varchar" />
			AND classification_levels.name = 
				<cfqueryparam value="#classification_level#" cfsqltype="cf_sql_varchar" />
			AND jobs.branch = 
				<cfqueryparam value="#branch#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfset event.setArg('response_structure', query) />
	</cffunction>
	
<!------------------------------------------------------------------------------------------ getJobId

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="getJobId">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var title = event.getArg('title') />
		<cfset var classification = event.getArg('classification') />
		<cfset var classification_level = event.getArg('classification_level') />
		<cfset var branch = event.getArg('branch') />
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#request.dsn#">
			SELECT jobs.id
			FROM jobs
			JOIN classification_levels 
				ON jobs.classification_level_id = classification_levels.id
			JOIN classifications 
				ON classification_levels.classification_id = classifications.id
			WHERE jobs.title = 
				<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar" />
			AND classifications.name = 
				<cfqueryparam value="#classification#" cfsqltype="cf_sql_varchar" />
			AND classification_levels.name = 
				<cfqueryparam value="#classification_level#" cfsqltype="cf_sql_varchar" />
			AND jobs.branch = 
				<cfqueryparam value="#branch#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfif query.recordcount NEQ 1>
			<cfthrow message="Job was not unique or could not be found" />
		</cfif>

		<cfset event.setArg('response_structure', query) />
	</cffunction>
</cfcomponent>
