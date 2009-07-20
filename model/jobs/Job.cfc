<cfcomponent extends="supermodel.datamodel">	
<!------------------------------------------------------------------------------------------- configure

	Description:	
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="configure">
		<cfset variables.table_name = 'jobs' />
		
		<cfset this.display = false />
		<cfset this.draft = false />
		<cfset this.classification_id = "" />
		
		<cfset belongsTo('classification_level', 'hr_staffing.model.classification_levels.ClassificationLevel') />
	</cffunction>	


	
<!------------------------------------------------------------------------------------- groupAndLevel

	Description:	
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="groupAndLevel" access="public" returntype="string">
		<cfreturn this.classification_level.classification.name & "-" & this.classification_level.name />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- hasPositions

	Description:	
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="hasPositions" access="public" returntype="boolean">
		<cfset var query = "" />
		
		<cfquery name="query" datasource="#variables.dsn#">
			SELECT count(*) AS num_positions
			FROM positions WHERE positions.job_id = 
				<cfqueryparam value="#this.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn query.num_positions NEQ 0>
	</cffunction>
	
<!--------------------------------------------------------------------------------------- canBeDeleted

	Description:	
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="canBeDeleted" access="public" returntype="boolean">
		<cfif hasPositions()>
			<cfset structInsert(variables.errors, 'positions', 'The job cannot be deleted because there are positions that reference the job.  You must delete or update those positions first.') />
			<cfreturn false />
		</cfif>
		
		<cfreturn true />
	</cffunction>
</cfcomponent>

