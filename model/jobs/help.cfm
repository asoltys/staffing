<cfswitch expression="#field#">

	<cfcase value="title">
		<cfset help_message = "The name of the job" />
	</cfcase>
	
	<cfcase value="classification_id">
		<cfset help_message = "The job's classification group" />
	</cfcase>
	
	<cfcase value="classification_level_id">
		<cfset help_message = "The level of the job's classification" />
	</cfcase>
	
	<cfcase value="branch">
		<cfset help_message = "The branch that the job belongs to" />
	</cfcase>
	
	<cfcase value="location">
		<cfset help_message = "The location of the job" />
	</cfcase>
	
</cfswitch>