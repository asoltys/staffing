<cfcomponent
	extends="MachII.mach-ii"
	output="false">

	<!---
	PROPERTIES - APPLICATION SPECIFIC
	--->
	<cfset this.name = "Pacific Intranet" />
	<cfset this.loginStorage = "session" />
	<cfset this.sessionManagement = true />
	<cfset this.setClientCookies = false />
	<cfset this.setDomainCookies = false />
	<cfset this.sessionTimeOut = CreateTimeSpan(0,12,0,0) />
	<cfset this.applicationTimeOut = CreateTimeSpan(1,0,0,0) />
	
	<cfsetting enablecfoutputonly="yes" />

	<!---
	PROPERTIES - MACH-II SPECIFIC
	--->
	<!---Set the path to the application's mach-ii.xml file --->
	<cfset MACHII_CONFIG_PATH = ExpandPath("./config/mach-ii.xml") />
	<!--- Set the app key for sub-applications within a single cf-application. --->
	<cfset MACHII_APP_KEY =  GetFileFromPath(ExpandPath(".")) />
	<!--- Set the configuration mode (when to reinit): -1=never, 0=dynamic, 1=always --->
	<cfset MACHII_CONFIG_MODE = -1 />
	<!--- Whether or not to validate the configuration XML before parsing. Default to false. --->
	<cfset MACHII_VALIDATE_XML = FALSE />
	<!--- Set the path to the Mach-II's DTD file. --->
	<cfset MACHII_DTD_PATH = ExpandPath("/MachII/mach-ii_1_1_1.dtd") />

	<cffunction name="onApplicationStart" returnType="void" output="false"
		hint="Only runs when the App is started.">
			
		<cfsetting requesttimeout="120" />
		<cfset application.startTime = Now() />
    
    <!--- Server settings includes variables for the DSN, path, and server type --->
		<cfinclude template="server_settings.cfm" />
    
		<cfset LoadFramework() />
	</cffunction>

	<cffunction name="onRequestStart" returnType="void" output="true"
		hint="Run at the start of a page request.">
		<cfargument name="targetPage" type="string" required="true" />
				
		<cfset request.current_fiscal_year = year(dateadd('m', -3, now()))/>
		
		<!--- Server settings includes variables for the DSN, path, and server type --->
		<cfinclude template="server_settings.cfm" />	

		<!--- Request Scope Variable Defaults --->
		<cfset request.self = "index.cfm">

    <cfif not structKeyExists(session, 'staffing_region') or session.staffing_region eq ''>
      <cfif structKeyExists(request, 'current_user')>
        <cfset session.staffing_region = request.current_user.getRegion().id />
      <cfelse>
        <cfset session.staffing_region = '' />
      </cfif>
    </cfif>

		<cfif StructKeyExists(session, "cfid") AND (NOT StructKeyExists(cookie, "cfid") OR NOT StructKeyExists(cookie, "cftoken"))>
			<cfcookie name="cfid" value="#session.cfid#" />
			<cfcookie name="cftoken" value="#session.cftoken#" />
		</cfif>

		<!--- Temporarily override the default config mode
			Set the configuration mode (when to reinit): -1=never, 0=dynamic, 1=always --->
		<cfif StructKeyExists(url, "reinit")>
			<cfsetting requesttimeout="120" />
			<cfset MACHII_CONFIG_MODE = 1 />
		</cfif>

		<!--- Handle the request. Make sure we only process Mach-II requests. --->
		<cfif findNoCase('index.cfm', listLast(arguments.targetPage, '/'))>
			<cfset handleRequest() />
		</cfif>
	</cffunction>
	
	<!--- Request end --->
	<cffunction name = "onRequestEnd">
		<cfargument type = "String" name = "targetPage" required = "true" />
	</cffunction>
</cfcomponent>
