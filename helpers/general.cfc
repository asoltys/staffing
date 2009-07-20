<cfcomponent>

	<!--------------------------------------------------------------------- updateProcessStatusesAndPhases
	
		Description:	
				
	----------------------------------------------------------------------------------------------------->	
		
	<cffunction name="updateProcessStatusesAndPhases" access="public" returntype="void">
		 <cfstoredproc procedure="UpdateProcesses" datasource="#request.dsn#" />
	</cffunction>

</cfcomponent>