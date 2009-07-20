<cfcomponent extends="SuperModel.Gateway">
<!------------------------------------------------------------------------------------------ configure

	Description:	Carries out the configuration required for this object to act as a SuperModel
			
----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.table_name = 'activities' />
	</cffunction>
	
<!--------------------------------------------------------------------------------------- selectQuery

	Description:	Private function that executes a SELECT SQL query.  We are overriding it here so that
								we can select the phase which the activity belongs to.
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="selectQuery" access="private">
		<cfargument name="order_by" required="yes" />
		<cfargument name="sort_direction" required="yes" />
		<cfargument name="conditions" required="yes" />
		<cfargument name="columns" required="yes" />
				
		<cfquery name="SelectObject" datasource="#variables.dsn#" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
			SELECT staffing_activities.*, phases.name AS phase
			FROM staffing_activities
			JOIN phases on staffing_activities.phase_id = phases.id
			<cfif arguments.conditions NEQ "">
			WHERE #PreserveSingleQuotes(arguments.conditions)#
			</cfif>
			<cfif arguments.order_by NEQ "">
			ORDER BY #Arguments.order_by# #sort_direction#
			</cfif>
		</cfquery>
	</cffunction>
</cfcomponent>