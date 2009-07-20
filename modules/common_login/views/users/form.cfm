<cfset user = event.getArg('user') />
<cfset roles = event.getArg('roles') />

<cfoutput>

<h1>User</h1>

<form action="#request.path#index.cfm?event=common_login:users.process" method="post">
	<fieldset>
		<legend>User Form</legend>
		<input id="login" name="login" type="hidden" value="#user.login#" />
		
		<label for="role_id">Role</label>
		<select id="role_id" name="role_id">
			<option>Select One</option>
			<cfloop condition="#roles.next()#">
			<cfset role = roles.current() />
			
			<cfset selected = "" />
			<cfif role.id eq user.role.id>
				<cfset selected="selected=""selected""" />
			</cfif>
			
			<option value="#role.id#" #selected#>#role.name#</option>
			</cfloop>
		</select>
		
		<br />
		
		<input type="submit" name="submit_button" id="submit_button" class="submitButton" value="Submit" />
	</fieldset>
</form>

</cfoutput>