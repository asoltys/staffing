<!-------------------------------------------------------------------------------------------- region

	Description:	Represents a region from common login.  Client applications may want to extend this
								component if they have additional attributes or methods to associate with a region
	
---------------------------------------------------------------------------------------------------->

<cfcomponent extends="supermodel.DataModel">
  
<!---------------------------------------------------------------------------------------------- configure

	Description:	Constructs the object by reading all the columns from the database and creating 
								private member variables for each field.
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="configure" access="public" returntype="void">
    <cfset addProperty('id', 'int') />
    <cfset addProperty('name', 'varchar') />
    <cfset addProperty('acronym', 'varchar') />

		<cfset variables.table_name = 'common_login..regions' />
		<cfset variables.dsn = 'common_login' />
		<cfset variables.common_login_dsn = "common_login" />
	</cffunction>
	
<!---------------------------------------------------------------------------------------------- read

	Description:	regions are special in that they can read from either an acronym or an id
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="read" access="public" returntype="void">
		<cfargument name="id" type="any" required="yes" />
			
		<cfif NOT isNumeric(arguments.id)>
			<cfquery name="getregionID" datasource="#variables.common_login_dsn#">
				SELECT id 
				FROM regions 
				JOIN region_acronyms
				  ON regions.id = region_acronyms.region_id
				WHERE region_acronyms.acronym = 
					<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfif getregionID.recordcount NEQ 1>
				<cfthrow message="Could not find region, must provide a numeric id or acronym" />
			</cfif>
			
			<cfset arguments.id = getregionID.id />
		</cfif>
		
		<cfset super.read(arguments.id) />
	</cffunction>
</cfcomponent>

