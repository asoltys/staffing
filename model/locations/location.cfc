<cfcomponent extends="supermodel.DataModel">	
	
	<cffunction name="configure">
		<cfset variables.table_name = 'locations' />

    <cfset addProperty('name', 'varchar') />
	</cffunction>	

</cfcomponent>