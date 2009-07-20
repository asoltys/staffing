<cfcomponent extends="MachII.framework.Listener">

<!----------------------------------------------------------------------------------------- configure

	Description:	Create an empty struct to hold all the position objects for the application

---------------------------------------------------------------------------------------------------->

	<cffunction name="configure" access="public" output="false" returntype="void"
			hint="Configures this listener as part of the Mach-II framework">
	</cffunction>

<!------------------------------------------------------------------------------------------- process

	Description:	Send the user's login credentials to the common login application for verification.
								We pass the application name so that the common login knows which application they
								are trying to log in from.

---------------------------------------------------------------------------------------------------->

	<cffunction name="process" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />

		<cfset var login = event.getArg('login') />
		<cfset var password = event.getArg('password') />
		<cfset var loginService = getProperty('beanFactory').getBean('loginService') />
		<cfset var userService = getProperty('beanFactory').getBean('userService') />
		<cfset var user = userService.getUser() />
		<cfset var application_name = user.getApplication() />

		<cflock timeout="60" scope="session" type="exclusive">
			<cfif loginService.authenticate(login = login, password = password,	application_name = application_name)>
				<cfset session.login = login />
				<cfset user.readOrCreateFromLogin(login) />
				<cfset structInsert(session, 'user', user, true) />
				<cfset request.current_user = user />
				<cfset event.setArg('user',user) />
				<cfset event.setArg('response_structure', 'true') />
			<cfelse>
				<cfset event.setArg('login', login) />
				<cfset event.setArg('response_structure', 'false') />
			</cfif>
		</cflock>

	</cffunction>

<!-------------------------------------------------------------------------------------------- logout

	Description:	Log the current user out of the system.

---------------------------------------------------------------------------------------------------->

	<cffunction name="logout" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfset structClear(session) />
	</cffunction>
</cfcomponent>
