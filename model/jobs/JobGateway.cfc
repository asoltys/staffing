<cfcomponent extends="supermodel.Gateway">

<!------------------------------------------------------------------------------------------ configure

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.table_name = 'jobs' />		
	</cffunction>
	
<!-------------------------------------------------------------------------------------------- select

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="select" access="public" returntype="query">
		<cfargument name="classification_level_id" default="" />
		<cfargument name="branch" default="" />
		<cfargument name="location" default="" />
		<cfargument name="status" default="" />
		<cfargument name="approval" default="" />
		<cfargument name="sorting" default="" />	
		<cfargument name="role" default="" />			
				
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT 
				jobs.*,
				classifications.id AS classification_id,
				classifications.name AS classification_name,
				classification_levels.name AS classification_level_name
			FROM jobs
				JOIN classification_levels ON classification_levels.id = jobs.classification_level_id
				JOIN classifications ON classifications.id = classification_levels.classification_id
			WHERE 1 = 1
			<cfif arguments.classification_level_id neq ''>
			AND jobs.classification_level_id = <cfqueryparam value="#arguments.classification_level_id#" cfsqltype="cf_sql_integer" />
			</cfif>
			<cfif arguments.branch neq ''>
			AND jobs.branch = <cfqueryparam value="#arguments.branch#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif arguments.location neq ''>
			AND jobs.location = <cfqueryparam value="#arguments.location#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif arguments.role eq 'public'>
			AND jobs.display = 1
			</cfif>
			<cfif arguments.status neq '' and arguments.role neq 'public'>
				<cfif arguments.status eq 'hidden'>
				AND jobs.display = 0
				<cfelseif arguments.status eq 'published'>
				AND jobs.display = 1
				</cfif>				
			</cfif>
			<cfif arguments.approval eq 'needApproval'>
			AND jobs.id IN (#requireApproval()#)
			</cfif>
			ORDER BY jobs.title
		</cfquery>
		
		<cfreturn query />
	</cffunction>
	
<!-------------------------------------------------------------------------- selectExistingJobTitles

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="selectExistingJobTitles" access="public" returntype="query">
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT DISTINCT title 
			FROM jobs
		</cfquery>
		
		<cfreturn query />
	</cffunction>
	
</cfcomponent>