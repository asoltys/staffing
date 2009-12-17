<cfcomponent extends="MachII.framework.EventFilter">
	<cffunction name="configure" returntype="void" access="public" output="false">
		<!--- perform any initialization --->
	</cffunction>
	
<!--------------------------------------------------------------------------------------- filterEvent

	Description:	This is the function that gets called whenever the authenticate filter is added
								to an event-handler.
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="filterEvent" returntype="boolean" access="public" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="yes" />
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="yes" />
		<cfargument name="paramArgs" type="struct" required="yes" />
				
		<cfset var user = request.current_user />
		
		<cfif user.isAuthenticated()>
			<cfset event.setArg('request.current_user', user) />
			
			<cfif NOT structKeyExists(paramArgs, 'permission') OR user.hasPermission(paramArgs['permission'])>
				<cfreturn true />		
			</cfif>		
		</cfif>
		
		<cflocation url="#request.path#index.cfm?event=permissionDenied" addtoken="no" />
		<cfreturn false />
	</cffunction>
</cfcomponent>