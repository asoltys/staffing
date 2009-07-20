<cfcomponent>
	<cfset this.name = "Pacific Intranet" />
	<cfset this.loginStorage = "session" />
	<cfset this.sessionManagement = true />
	<cfset this.setClientCookies = false />
	<cfset this.setDomainCookies = false />
	<cfset this.sessionTimeOut = CreateTimeSpan(0,12,0,0) />
	<cfset this.applicationTimeOut = CreateTimeSpan(1,0,0,0) />
	
	<cfsetting enablecfoutputonly="yes" />

  <cffunction name="onRequestStart" access="public" returntype="void" type="html">
    <cfargument name="targetPage" type="string" required="yes">

    <cfinclude template="../server_settings.cfm" />
    <cfinvoke method="setupRequest" component="cms.helpers.helpers" user_path="hr_staffing.model.users.user" />
  </cffunction>
</cfcomponent>
