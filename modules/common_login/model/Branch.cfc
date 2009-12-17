<!-------------------------------------------------------------------------------------------- Branch

	Description:	Represents a branch from common login.  Client applications may want to extend this
								component if they have additional attributes or methods to associate with a branch
	
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

		<cfset variables.table_name = 'common_login..branches' />
		<cfset variables.dsn = 'common_login' />
		<cfset variables.common_login_dsn = "common_login" />
	</cffunction>
	
<!---------------------------------------------------------------------------------------------- read

	Description:	Branches are special in that they can read from either an acronym or an id
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="read" access="public" returntype="void">
		<cfargument name="id" type="any" required="yes" />
			
		<cfif NOT isNumeric(arguments.id)>
			<cfquery name="getBranchID" datasource="#variables.common_login_dsn#">
				SELECT id 
				FROM branches 
				JOIN branch_acronyms
				  ON branches.id = branch_acronyms.branch_id
				WHERE branch_acronyms.acronym = 
					<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfif getBranchID.recordcount NEQ 1>
				<cfthrow message="Could not find Branch, must provide a numeric id or acronym" />
			</cfif>
			
			<cfset arguments.id = getBranchID.id />
		</cfif>
		
		<cfset super.read(arguments.id) />
	</cffunction>
</cfcomponent>
