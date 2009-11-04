<cfcomponent extends="MachII.framework.Listener">
		
<!----------------------------------------------------------------------------------------- configure

	Description:	Create an empty struct to hold all the position objects for the application
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="configure" access="public" output="false" returntype="void" 
			hint="Configures this listener as part of the Mach-II framework">
	</cffunction>
	
<!----------------------------------------------------------------------------------------- birds_eye

	Description:	
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="birds_eye" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

	</cffunction>
</cfcomponent>
