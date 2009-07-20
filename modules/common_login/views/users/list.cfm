<cfset app = event.getArg('app') />
<cfset roles = event.getArg('roles') />
<cfset potential_users = event.getArg('potential_users') />
<cfset potential_roles = event.getArg('potential_roles') />

<cfoutput>

<h1>User List</h1>

<div class="mockForm">
	<h2>Current Users</h2>
	<ul>
	<cfloop condition="#roles.next()#">
		<cfset role = roles.current() />
		<cfset request.current_users = app.getUsersByRole(role) />
		<cfif request.current_users.length() GT 0>
				<li><a href="###role.name#">#role.name#</a></li>
		</cfif>
	</cfloop>
	</ul>
</div>
<p>
	<a class="addLink" href="##addUsers">Add Potential Users</a>
</p>
<cfset roles.reset() />
<cfloop condition="#roles.next()#">
	<cfset role = roles.current() />
	<cfset request.current_users = app.getUsersByRole(role) />
	<cfset request.current_users.order('first_name, last_name') />
	<cfif request.current_users.length() GT 0>
		<h3><a name="#role.name#"></a>#role.name#</h3>
		<table class="list">
		<cfloop condition="#request.current_users.next()#">
			<cfset user = request.current_users.current() />

				<tr>
					<td>
						<a href="#request.path#index.cfm?event=common_login:users.form&amp;login=#user.login#">
							#user.first_name# #user.last_name#
						</a>
					</td>
					<td class="icon">
						<a href="#request.path#index.cfm?event=common_login::users.delete&login=#user.login#" title="Delete User" class="deleteLink">
							<span>Delete User</span>
						</a>
					</td>
				</tr>
		</cfloop>
		</table>
	</cfif>
</cfloop>

<a name="addUsers"></a><h2 class="noPrint">Potential Users</h2>

<form action="index.cfm?event=common_login:users.add" method="post" class="noPrint">

	<fieldset>
		<legend>Add User</legend>
		<select id="user_logins" name="user_logins" multiple="multiple" style="height:120px">
			<cfloop condition="#potential_users.next()#">
				<cfset user = potential_users.current() />

				<option value="#user.login#">#user.getName()#</option>
			</cfloop>
		</select>
		<br />
		<select id="role_id" name="role_id">
			<cfloop condition="#potential_roles.next()#">
				<cfset role = potential_roles.current() />

				<option value="#role.id#">#role.name#</option>
			</cfloop>
		</select>
		<br />
		<input id="submit_users" name="submit" class="submitButton" type="submit" value="Add Users" />
	</fieldset>

</form>

</cfoutput>
