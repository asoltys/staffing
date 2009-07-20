<cfcomponent extends="supermodel.datamodel">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.object_path = 'hr_staffing.model.positions.action' />
		<cfset variables.table_name = 'actions' />
	</cffunction>
	
	<cffunction name="readFromField" access="public" returntype="void" output="false">
		<cfargument name="field" type="numeric" required="yes" />
		
		<cfquery name="select_action" datasource="#variables.dsn#">
			SELECT id
			FROM actions 
			WHERE field = <cfqueryparam value="#arguments.field#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfset read(select_action.id) />
	</cffunction>
</cfcomponent>