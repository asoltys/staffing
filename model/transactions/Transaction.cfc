<cfcomponent extends="supermodel.DataModel">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.table_name = 'transactions' />
		<cfset belongsTo('process_activity', 'hr_staffing.model.process_activities.ProcessActivity') />
		<cfset belongsTo('user', 'hr_staffing.model.users.user') />
	</cffunction>

<!------------------------------------------------------------------------------------------ getAction

	Description:

----------------------------------------------------------------------------------------------------->

	<cffunction name="getAction" access="public" returntype="string">
		<cfswitch expression="#this.action#">
			<cfcase value="est_completion_date">
				<cfreturn "Estimated Completion Date" />
			</cfcase>

			<cfcase value="completion_date">
				<cfreturn "Completion Date" />
			</cfcase>

			<cfcase value="endangered_time">
				<cfreturn "At Risk Lead Time" />
			</cfcase>

			<cfcase value="status_id">
				<cfreturn "Status" />
			</cfcase>
		</cfswitch>
	</cffunction>


<!------------------------------------------------------------------------------------------ getValue

	Description:

----------------------------------------------------------------------------------------------------->


	<cffunction name="getValue" access="public" returntype="string">
		<cfargument name="attribute" type="string" required="yes" />

		<cfset var status = '' />
		<cfif this.action EQ 'status_id' AND isNumeric(this[arguments.attribute])>
			<cfset status = createObject('component', 'hr_staffing.model.statuses.status') />
			<cfset status.init(variables.dsn) />
			<cfset status.read(this[arguments.attribute]) />
			<cfreturn status.name />
		</cfif>

		<cfif isDate(this[arguments.attribute])>
			<cfreturn LSDateFormat(ParseDateTime(this[arguments.attribute]), "yyyy-mm-dd") />
		</cfif>

		<cfreturn this[arguments.attribute] />
	</cffunction>
</cfcomponent>