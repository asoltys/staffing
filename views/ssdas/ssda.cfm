<cfset process = event.getArg('process') />
<cfset process_activities = event.getArg('process_activities') />
<cfset statuses = event.getArg('statuses') />
<cfset comments = event.getArg('comments') />
<cfinclude template="#request.includes_path#views/ssdas/ssda_scripts.cfm" />
<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfoutput>

<link href="#request.path#css/ssda.css" rel="stylesheet" type="text/css" />

<cfif request.current_user.hasRole("HR Staff")>
	<p class="group">
		<a href="#request.path#index.cfm?event=processes.ssda&amp;process_id=#event.getArg('process_id')#&amp;view=HR%20Staff" <cfif event.getArg('view') EQ 'HR Staff' or not event.isArgDefined('view')>class="active"</cfif>>Admin View</a> |
		<a href="#request.path#index.cfm?event=processes.ssda&amp;process_id=#event.getArg('process_id')#&amp;view=Manager" <cfif event.getArg('view') EQ 'Manager'>class="active"</cfif>>Manager View</a> |
		<a href="#request.path#index.cfm?event=processes.ssda&amp;process_id=#event.getArg('process_id')#&amp;view=Public" <cfif event.getArg('view') EQ 'Public'>class="active"</cfif>>Employee View</a>
	</p>
</cfif>

<cfif event.isArgDefined('view')>
	<cfset request.current_user.role.name = event.getArg('view') />
</cfif>

<h1>Staffing Activities</h1>


<cfinvoke method="process_details" process="#process#" displayPositions="true" />

<cfif request.current_user.hasRole("HR Staff")>
	<cfinclude template="edit.cfm" />
<cfelseif request.current_user.hasRole("Manager")>
	<cfinclude template="manager.cfm" />
<cfelse>
	<cfinclude template="public.cfm" />
</cfif>

<cfif request.current_user.hasRole("HR Staff,Manager")>
	<cfif comments.length() GT 0>
		<h2>Comments</h2>
			
		<ol class="com-list">
			<cfloop condition="#comments.next()#">
			<cfset comment = comments.current() />
				<li id="comment-#comment.id#">
					<cfif request.current_user.hasRole('HR Staff')>
						<a href="#request.path#index.cfm?event=processes.remove_comment&amp;comment_id=#comment.id#&amp;process_id=#process.id#" class="delete noPrint">
							<img src="#request.parent_path#images/applications/comment-remove.gif" alt="[x]" title="Delete Comment" />
						</a> 
					</cfif>
					<h3>	
						#comment.user.first_name# #comment.user.last_name#
					</h3>
					<p>#comment.comment#</p>		
					<p class="com-meta">
						#DateFormat(comment.date, "mmmm dd, yyyy")# at #TimeFormat(comment.date, "h:mm tt")#
					</p>
				</li>
			</cfloop>
		</ol>
	</cfif>

	<cfif request.current_user.hasRole("HR Staff")>
		<form name="add_comment" method="post" action="#request.path#index.cfm?event=processes.add_comment" class="noPrint comment">
			<fieldset>
				<legend>Comment Form</legend>
				<h2>New Comment</h2>
				<textarea name="comment" id="comment"></textarea>
				<input type="hidden" name="process_id" id="process_id" value="#process.id#" />
				<input type="hidden" name="user_id" id="user_id" value="#request.current_user.id#" />
				<input type="hidden" name="date" id="date" value="#now()#" />
	
				<br />
				<input type="submit" name="submit_button" id="submit_button" value="Post Comment" class="submitButton"/>
			</fieldset>
		</form>
	</cfif>
</cfif>

</cfoutput>