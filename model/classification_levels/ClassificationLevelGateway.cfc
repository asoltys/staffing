<cfcomponent extends="supermodel.Gateway">

<!------------------------------------------------------------------------------------------ configure

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.table_name = 'classification_levels' />
	</cffunction>
	
<!--------------------------------------------------------------------------------------------- select

	Description:
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="select" access="public" returntype="query">		
		<cfset var query = '' />

		<cfquery name="query" datasource="#variables.dsn#" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
			SELECT 
				classification_levels.id,
				classification_levels.name, 
				classifications.id AS classification_id,
				classifications.name AS classification_name
			FROM classification_levels 
			JOIN classifications
				ON classification_levels.classification_id = classifications.id		
      ORDER BY classifications.name, classification_levels.name
		</cfquery>
		
		<cfreturn query />
	</cffunction>
</cfcomponent>
