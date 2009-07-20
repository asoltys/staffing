<cfswitch expression="#field#">
	<cfcase value="title">
		<cfset help_message = "The position title" />
	</cfcase>
	
	<cfcase value="number">
		<cfset help_message = "The position number" />
	</cfcase>
	
	<cfcase value="group_level">
		<cfset help_message = "A number representing which group or level this position belongs to" />
	</cfcase>
	
	<cfcase value="branch_id">
		<cfset help_message = "The branch that the position is in" />
	</cfcase>
	
	<cfcase value="manager_id">
		<cfset help_message = "The manager of the branch that the position is in" />
	</cfcase>
</cfswitch>