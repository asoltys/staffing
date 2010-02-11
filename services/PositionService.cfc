<cfcomponent>

<!--------------------------------------------------------------------------------------------- init

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="init" access="public" returntype="void" output="false">
		<cfargument name="object" type="any" required="yes" />
		<cfargument name="gateway" type="any" required="yes" />
		
		<cfset variables.position = arguments.object />
		<cfset variables.positionGateway = arguments.gateway />
	</cffunction>
	
<!-------------------------------------------------------------------------------------- getPositions

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="getPositions" access="remote" returntype="array" output="true">
		<cfset var position_query = variables.positionGateway.select() />
		<cfset var position_list = createObject('component', 'supermodel.ObjectList') />
		<cfset var position_array = ArrayNew(1) />

		<cfset position_list.init(
			variables.position,
			position_query) />
						
		<cfset position_array = position_list.toArray() />
	
		<cfreturn position_array />
	</cffunction>
	
<!------------------------------------------------------------------------------------------- getList

	Description:
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="getList" access="remote" returntype="supermodel.ObjectList" output="true">
		<cfargument name="parameters" type="struct" default="#StructNew()#" />
		
		<cfset var position_query = "" />
		<cfset var position_list = createObject('component', 'supermodel.ObjectList') />
		<cfset var conditions = "1=1" />

    <cfif not structKeyExists(arguments, 'region_id') or arguments.parameters.region_id eq ''>
      <cfif structKeyExists(session, 'staffing_region') and session.staffing_region neq ''>
        <cfset arguments.parameters.region_id = session.staffing_region />
      </cfif>
    </cfif>

    <cfif structKeyExists(arguments.parameters, 'region_id') and arguments.parameters.region_id neq ''>
      <cfset conditions = conditions & " AND common_login..regions.id = '" & arguments.parameters.region_id & "'"/>
    </cfif>

    <cfif not structKeyExists(arguments.parameters, 'fiscal_year') OR arguments.parameters.fiscal_year EQ "">
      <cfset arguments.parameters.fiscal_year = Year(DateAdd('m',-3,Now())) />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'process_id') AND arguments.parameters['process_id'] NEQ "">
      <cfset conditions = conditions & " AND positions.process_id= '" & arguments.parameters['process_id'] & "'"/>
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'branch') AND arguments.parameters['branch'] NEQ "">
      <cfset conditions = conditions & " AND jobs.branch = '" & arguments.parameters['branch'] & "'"/>
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'location') AND arguments.parameters['location'] NEQ "">
      <cfset conditions = conditions & " AND positions.location = '" & arguments.parameters['location'] & "'" />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'classification_id') AND arguments.parameters['classification_id'] NEQ "">
      <cfset conditions = conditions & " AND classifications.id = " & arguments.parameters['classification_id'] />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'classification_level_id') AND arguments.parameters['classification_level_id'] NEQ "">
      <cfset conditions = conditions & " AND classification_levels.id = " & arguments.parameters['classification_level_id'] />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'user_id') AND arguments.parameters['user_id'] NEQ "">
      <cfset conditions = conditions & " AND positions.id IN (SELECT position_id FROM positions_users WHERE user_id = " & arguments.parameters['user_id'] & ")" />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'unassigned') AND arguments.parameters['unassigned'] EQ true>
      <cfset conditions = conditions & " AND positions.id NOT IN (SELECT position_id FROM positions_users)" />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'manager_id') AND arguments.parameters['manager_id'] NEQ "">
      <cfset conditions = conditions & " AND positions.manager_id = " & arguments.parameters['manager_id'] />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'job_id') AND arguments.parameters['job_id'] NEQ "">
      <cfset conditions = conditions & " AND positions.job_id = " & arguments.parameters['job_id'] />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'status_id') AND arguments.parameters['status_id'] NEQ "">
      <cfset conditions = conditions & " AND processes.status_id = " & arguments.parameters['status_id'] />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'phase_id') AND arguments.parameters['phase_id'] NEQ "">
      <cfset conditions = conditions & " AND processes.phase_id = " & arguments.parameters['phase_id'] />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'security_level_id') AND arguments.parameters['security_level_id'] NEQ "">
      <cfset conditions = conditions & " AND positions.security_level_id = " & arguments.parameters['security_level_id'] />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'staffing_method_id') AND arguments.parameters['staffing_method_id'] NEQ "">
      <cfset conditions = conditions & " AND processes.staffing_method_id = " & arguments.parameters['staffing_method_id'] />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'tenure_id') AND arguments.parameters['tenure_id'] NEQ "">
      <cfset conditions = conditions & " AND positions.tenure_id = " & arguments.parameters['tenure_id'] />
    </cfif>
    
    <cfif structKeyExists(arguments.parameters, 'collective') AND arguments.parameters['collective'] NEQ "">
      <cfset conditions = conditions & " AND processes.collective = " & arguments.parameters['collective'] />
    </cfif>

    <cfif structKeyExists(arguments.parameters, 'infrastructure') AND arguments.parameters['infrastructure'] NEQ "">
      <cfset conditions = conditions & " AND positions.infrastructure = " & arguments.parameters['infrastructure'] />
    </cfif>
    
    <cfif NOT structKeyExists(arguments.parameters, 'archived') OR arguments.parameters.archived EQ false>
      <cfset conditions = conditions & " 
      AND (positions.fiscal_year = " & arguments.parameters['fiscal_year'] & "
      OR YEAR(DATEADD(m,-3,processes.completion_date)) = " & arguments.parameters['fiscal_year'] & "
      OR YEAR(DATEADD(m,-3,processes.cancelation_date)) = " & arguments.parameters['fiscal_year'] & "
      OR (processes.completion_date IS NULL AND processes.cancelation_date IS NULL
        AND " & arguments.parameters['fiscal_year'] & " = " & Year(DateAdd('m', -3, Now())) & 
      "))" />
    <cfelse>
      <cfset conditions = conditions & "AND (
        YEAR(DATEADD(m,-3,processes.completion_date)) = " & arguments.parameters['fiscal_year'] & " OR
        YEAR(DATEADD(m,-3,processes.cancelation_date)) = " & arguments.parameters['fiscal_year'] & ")">
    </cfif>


		<cfset position_query = variables.positionGateway.select(conditions = conditions) />

		<cfset position_list.init(
			variables.position,
			position_query) />
	
		<cfreturn position_list />
	</cffunction>	
	
<!------------------------------------------------------------------------------------- savePosition

	Description:
	
---------------------------------------------------------------------------------------------------->
	
	<cffunction name="savePosition" access="remote" returntype="hr_staffing.model.positions.Position">
		<cfargument name="position" type="hr_staffing.model.positions.Position" required="yes" />
			
		<cfset arguments.position.configure() />
		<cfset arguments.position.init(variables.dsn) />
		<cfset arguments.position.save() />
		
		<cfreturn arguments.position />
	</cffunction>		
</cfcomponent>
