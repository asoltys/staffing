<cfcomponent>
  <cfset this.name = "Pacific Intranet" />
	<cfset this.loginStorage = "session" />
	<cfset this.sessionManagement = true />
	<cfset this.setClientCookies = false />
	<cfset this.setDomainCookies = false />
	<cfset this.sessionTimeOut = CreateTimeSpan(0,12,0,0) />
	<cfset this.applicationTimeOut = CreateTimeSpan(1,0,0,0) />
	
	<cfsetting enablecfoutputonly="yes" />
  
  <cffunction name="onRequest" access="public" returntype="void">
		<cfargument name="targetPage" type="string" required="yes" />

		<cfinclude template="../server_settings.cfm" />

		<cfinvoke component="cms.helpers.helpers" method="setupRequest" user_path="hr_staffing.model.users.user" />
		<cfinvoke component="cms.helpers.helpers" method="includePage" targetPage="#arguments.targetPage#" />
	</cffunction>

</cfcomponent>
