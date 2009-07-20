<!--- Server Specific Configuration --->
<cfset request.dsn = "human_resources" />
<cfset request.cms_dsn = "common_login" />
<cfset request.path = "/applications/staffing/" />
<cfset request.parent_path = "/" />
<cfset request.parent_include_path = "/renewal/" />
<cfset request.includes_path = "/renewal/applications/staffing/" />
<cfset request.competency_path = request.parent_path & "applications/competency/" />
<cfset request.server_url = "http://renew.pac.pwgsc.gc.ca/" />
<cfset request.admin = "adam.soltys@pwgsc.gc.ca" />
<cfset request.human_resources_mailbox = "adam.soltys@pwgsc.gc.ca" />
<cfset request.server = "Production" />
<cfset setLocale("English (Canadian)") />
