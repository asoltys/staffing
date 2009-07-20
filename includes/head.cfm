<cfoutput>
<script src="#request.path#scripts/staffing_log.js" language="javascript" type="text/javascript"></script>
<link href="#request.parent_path#css/applications.css" media="screen, print" rel="stylesheet" type="text/css" />
<link href="#request.path#css/staffing.css" type="text/css" rel="stylesheet" media="screen, print" />
<link href="#request.path#css/print.css" type="text/css" rel="stylesheet" media="print" />

<cfswitch expression="#request.current_user.role.name#">
	<cfcase value="HR Staff">
		<link href="#request.path#css/admin.css" media="screen, print" rel="stylesheet" type="text/css" />
	</cfcase>
	<cfcase value="Manager">
		<link href="#request.path#css/manager.css" media="screen, print" rel="stylesheet" type="text/css" />
	</cfcase>
	<cfdefaultcase>
		<link href="#request.path#css/public.css" media="screen, print" rel="stylesheet" type="text/css" />
	</cfdefaultcase>
</cfswitch>
	
</cfoutput>
