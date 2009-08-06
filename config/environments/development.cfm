<!--- Server Specific Configuration --->
<cfset request.dsn = "human_resources" />
<cfset request.cms_dsn = "common_login" />
<cfset request.path = "/pacific_renewal/applications/staffing/" />
<cfset request.parent_path = "/pacific_renewal/" />
<cfset request.parent_include_path = "/pacific_renewal/" />
<cfset request.includes_path = "/pacific_renewal/applications/staffing/" />
<cfset request.competency_path = request.parent_path & "applications/competency/" />
<cfset request.server_url = "http://localhost:8501/pacific_renewal/applications/staffing/" />
<cfset request.admin = "adam.soltys@pwgsc-tpsgc.gc.ca" />
<cfset request.human_resources_mailbox = "adam.soltys@pwgsc-tpsgc.gc.ca" />
<cfset request.server = "Development" />
<cfset setLocale("English (Canadian)") />
