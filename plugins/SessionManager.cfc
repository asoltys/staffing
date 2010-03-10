<cfcomponent extends="MachII.framework.Plugin">

<!------------------------------------------------------------------------------------------ preEvent

	Description:	Inserts a User object into every event.
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="preEvent" access="public" output="true" returntype="void">
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="yes">
			
    <cfif structKeyExists(url, 'region')>
      <cfquery name="getRegion" datasource="common_login">
        SELECT id FROM regions WHERE acronym = 
          <cfqueryparam value="#url.region#" cfsqltype="cf_sql_varchar" />
      </cfquery>

      <cfset session.staffing_region = getRegion.id />
    </cfif>

	  <cfif 
      (not structKeyExists(session, 'staffing_region') 
      or session['staffing_region'] eq '')
      and cgi.query_string neq ''>
        <cflocation url="#request.path#index.cfm" addtoken="no" />
    </cfif>
    	
		<cfreturn />
	</cffunction>
</cfcomponent>
