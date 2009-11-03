<cfcomponent displayname="CommonLogin"
	hint="The common login API.  The following methods can be used by client applications to interface with the common login system.">

	<!---
		Since this component may be called from external applications we can't
		rely on request.dsn being set properly by Application.cfc.  We may want
		to make this configuration more robust in the future.
	--->
	<cfset variables.dsn = "common_login" />
	<cfset structInsert(session, 'messages', ArrayNew(1), true) />

<!-------------------------------------------------------------------------------- authenticate

	Description:	Validates the given login and password against the common login database

								If they cannot be found in the CL database then an LDAP query is executed to
								see if they have an LDAP account.  If they do have an LDAP account then we
								generate a CL account for them on-the-fly based on their LDAP credentials.

----------------------------------------------------------------------------------------------->

	<cffunction name="authenticate" access="remote" returntype="boolean"
		hint="Logs a user into the system.">
		<cfargument name="login" type="string" required="yes" />
		<cfargument name="password" type="string" required="yes" />
		<cfargument name="application_name" type="string" required="yes" />

		<!--- These local variables may hold query results or temporary values --->
		<cfset var SelectUser = "" />
		<cfset var SelectApplication = "" />

		<!--- Find the user --->
		<cfquery name="SelectUser" datasource="#variables.dsn#">
			SELECT users.id, users.password
			FROM  users
			WHERE users.login =
			  <cfqueryparam value="#Trim(arguments.login)#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<!--- Find the application --->
		<cfquery name="SelectApplication" datasource="#variables.dsn#">
			SELECT applications.id
			FROM  applications
			WHERE applications.name =
			  <cfqueryparam value="#arguments.application_name#" cfsqltype="cf_sql_varchar" />
		</cfquery>

    <!--- The application name couldn't be found --->
    <cfif SelectApplication.recordcount EQ 0>
      <cfif not structKeyExists(session, 'messages')>
      	<cfset session.messages = Arraynew(1) />
      </cfif>
      <cfset ArrayAppend(session.messages, "Application not found") />
      <cfreturn false />
    </cfif>

		<!--- The user was found --->
		<cfif SelectUser.recordcount EQ 1>
			<!--- Their password doesn't match --->
			<cfif Hash(arguments.password, 'MD5') NEQ SelectUser.password>

				<!--- Check if their password matches with the LDAP server --->
				<cfset ldapPassword = getLdapPassword(arguments.login, arguments.password) />

				<!--- Their password matches the LDAP server --->
				<cfif ldapPassword NEQ "" AND ldapPassword EQ arguments.password>

					<cfquery name="UpdatePassword" datasource="#variables.dsn#">
						UPDATE users
						SET password =
							<cfqueryparam value="#Hash(ldapPassword, 'MD5')#" cfsqltype="cf_sql_varchar">
						WHERE users.id =
							<cfqueryparam value="#SelectUser.id#" cfsqltype="cf_sql_integer" />
					</cfquery>

				<cfelse>
					<cfif not structKeyExists(session, 'messages')>
				      	<cfset session.messages = ArrayNew(1) />
      				</cfif>
					<cfset ArrayAppend(session.messages, "Invalid password") />
					<cfreturn false />
				</cfif>
			</cfif>

			<!--- Success! --->
			<cfreturn true />

		<!--- The user wasn't found --->
		<cfelse>
			<cftry>
				<cfldap
					action="query"
					name="ldapUser"
					attributes="sn,givenName,telephonenumber,mail"
					start="OU=ITSB,OU=BRANCH,OU=PAC,DC=ad,DC=pwgsc-tpsgc,DC=gc,DC=ca"
					server="dc-ncr-003.ncr.pwgsc.gc.ca"
					scope="subtree"
					filter="(mailNickname=#arguments.login#)"
					username="pwgsc-tpsgc-EM\#arguments.login#"
					password="#arguments.password#">

				<!--- The LDAP call failed --->
				<cfcatch type="any">
					<cfif not structKeyExists(session, 'messages')>
						<cfset session.messages = ArrayNew(1) />
					</cfif>
      				<cfset ArrayAppend(session.messages, "Invalid username or password") />
					<cfreturn false />
				</cfcatch>
			</cftry>

			<!---
				If no exception was thrown above then we proceed to create a CL account
				based on the LDAP information
			--->

			<!---
				We need to put something in for their location and department but
				for now we just get the first ones we can find
			 --->

		 <cfquery name="SelectLocation" datasource="#variables.dsn#">
			SELECT TOP 1 id FROM locations
			</cfquery>

			<cfquery name="SelectBranch" datasource="#variables.dsn#">
			SELECT TOP 1 id FROM branches
			</cfquery>

 			<cftry>
				<!--- Get a blank user object --->
				<cfobject name="user" component="common_login.model.users.User" />

				<!--- Initialize the user to use the correct dsn and application --->
				<cfset user.init(
					variables.dsn,
					'user',
					'common_login.model.users.User',
					'users',
					application.applicationname) />

				<!--- Set all the user's attributes --->
				<cfset user.login = arguments.login />
				<cfset user.password = hash(arguments.password, 'MD5') />
				<cfset user.first_name = ldapUser.sn />
				<cfset user.last_name = ldapUser.givenName />
				<cfset user.email = ldapUser.mail />
				<cfset user.phone = ldapUser.telephonenumber />
				<cfset user.location_id = SelectLocation.id />
				<cfset user.branch_id = SelectBranch.id />
				<cfset user.applications = SelectApplication.id />

				<!--- Save the user to the database --->
				<cfset user.save() />

				<cfcatch type="any">
					<cfif not structKeyExists(session, 'messages')>
				      	<cfset session.messages = ArrayNew(1) />
      				</cfif>
					<cfset ArrayAppend(session.messages, "Error creating new user") />
				</cfcatch>
			</cftry>

			<cfreturn true />
		</cfif>
	</cffunction>

<!------------------------------------------------------------------------------ getLdapPassword

	Description:	Returns the user's LDAP password if found or empty string if not.

----------------------------------------------------------------------------------------------->

	<cffunction name="getLdapPassword" access="private" returntype="string">
		<cfargument name="login" type="string" required="yes" />
		<cfargument name="password" type="string" required="yes" />

		<cftry>
			<cfldap
				action="query"
				name="ldapUser"
				attributes="password"
				start="OU=ITSB,OU=BRANCH,OU=PAC,DC=ad,DC=pwgsc-tpsgc,DC=gc,DC=ca"
				server="dc-ncr-003.ncr.pwgsc.gc.ca"
				scope="subtree"
				filter="(mailNickname=#arguments.login#)"
				username="pwgsc-tpsgc-EM\#arguments.login#"
				password="#arguments.password#">

			<cfreturn #arguments.password# />

			<cfcatch type="any">
				<cfreturn "">
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getList" access="remote" returntype="query">
		<cfset var branch_query = "" />

		<cfquery name="branch_query" datasource="#variables.dsn#">
			SELECT acronym AS name
			FROM branches
		</cfquery>

		<cfreturn branch_query />
	</cffunction>
</cfcomponent>