<!-------------------------------------------------------------------------------------------- Committee

	Description:	Represents a branch from common login.  Client applications may want to extend this
								component if they have additional attributes or methods to associate with a committee
	
---------------------------------------------------------------------------------------------------->

<cfcomponent extends="supermodel.DataModel">
  
<!---------------------------------------------------------------------------------------------- configure

	Description:	Constructs the object by reading all the columns from the database and creating 
								private member variables for each field.
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="configure" access="public" returntype="void">
		
		<cfset var fields = 'id,name,acronym' />
		<cfset var types = 'int,varchar,varchar' />

    <cfset addProperty('id', 'int') />
    <cfset addProperty('name', 'varchar') />
    <cfset addProperty('acronym', 'varchar') />

		<cfset variables.table_name = 'common_login..committees' />
		<cfset variables.dsn = 'common_login' />
		<cfset variables.common_login_dsn = "common_login" />
		<cfset hasMany('users', getPath() & 'User','user') />
	</cffunction>
</cfcomponent>
