<cfcomponent>
	<cffunction name="init" access="public" returntype="void" output="false">
		<cfargument name="dsn" type="string" required="yes" />
		
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	
	<cffunction name="addTransaction" access="public" returntype="void" output="false">
		<cfargument name="transaction" type="hr_staffing.model.transactions.transaction" required="yes" />
		
		<cfset var old_value = "" />
		<cfset var new_value = "" />
		
		<cfif structKeyExists(arguments.transaction, 'old_value')>
			<cfset old_value = arguments.transaction.old_value />
			
			<cfif isDate(old_value)>
				<cfset old_value = dateFormat(old_value, 'yyyy-mm-dd hh:mm') />
			</cfif>
		</cfif>
		
		<cfif structKeyExists(arguments.transaction, 'new_value')>
			<cfset new_value = arguments.transaction.new_value />
			
			<cfif isDate(new_value)>
				<cfset new_value = dateFormat(new_value, 'yyyy-mm-dd hh:mm') />
			</cfif>
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
			INSERT INTO transactions (
				user_id,
				process_id,
				activity_id,
				datetime,
				old_value,
				new_value,
				action)
			VALUES (
				<cfqueryparam value="#arguments.transaction.user.id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.transaction.processActivity.process_id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.transaction.processActivity.activity_id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#old_value#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#new_value#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.transaction.action#" cfsqltype="cf_sql_varchar" />
			)
		</cfquery>
				
	</cffunction>
</cfcomponent>