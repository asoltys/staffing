<cfcomponent>
	<cfset this.name = "Pacific Intranet" />
	<cfset this.loginStorage = "session" />
	<cfset this.sessionManagement = true />
	<cfset this.setClientCookies = false />
	<cfset this.setDomainCookies = false />
	<cfset this.sessionTimeOut = CreateTimeSpan(0,12,0,0) />
	<cfset this.applicationTimeOut = CreateTimeSpan(1,0,0,0) />
	
	<cffunction name="onRequest" access="public" returntype="boolean">
		<cfargument name="targetPage" type="string" required="yes" />
		
		<cfinclude template="../server_settings.cfm" />
    <cfset request.jquery = true />
		
		<cfinvoke component="cms.helpers.helpers" method="setupRequest" user_path="hr_staffing.model.users.User" />
		<cfinvoke component="cms.helpers.helpers" method="includePage" targetPage="#arguments.targetPage#" />
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="onRequestEnd" access="public" returntype="void">
		<cfset structDelete(session, 'messages') />
	</cffunction>
</cfcomponent>
