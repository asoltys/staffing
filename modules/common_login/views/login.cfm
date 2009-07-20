
<cfoutput>

<p><span id="login_message">Login using your Outlook Email credentials.</span></p>

<form id="login_form" action="#request.parent_path#applications/common_login/index.cfm?event=common_login:login.process" method="post">

	<input id="redirect_to" name="redirect_to" value="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" type="hidden" />
	<label for="login">Username</label>
	<input id="login" name="login" type="text" size="12"/>

	<br />

	<label for="password">Password</label>
	<input id="password" name="password" type="password" size="12"/>

	<br />

	<input type="submit" value="Login" />
	<input type="reset" value="Reset" />
</form>

</cfoutput>