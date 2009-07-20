<cfcomponent extends="supermodel.Gateway">
  <!------------------------------------------------------------------------------------------ configure

	Description:	Carries out the configuration required for this object to act as a SuperModel
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="configure" access="public" returntype="void">
		<cfset variables.table_name = 'locations' />
	</cffunction>
</cfcomponent>