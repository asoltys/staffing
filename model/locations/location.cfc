<cfcomponent extends="supermodel.DataModel">	
	
	<cffunction name="configure">
		<cfset variables.table_name = 'locations' />

    <cfset addProperty('name', 'varchar') />
    <cfset addProperty('region', 'varchar') />
	</cffunction>	
</cfcomponent>
