<cfoutput>

<form action="#request.path#index.cfm?event=processes.collective_processes" method="post">
	<fieldset>	
		<input id="user_id" name="user_id" type="hidden" value="#event.getArg('user_id')#" />
		<span class="dropdown">
			<label for="number" style="width:150px;">Process Number</label>
			<select name="number">
			<br />
			<option value="">All</option>
				<cfloop condition="#processes.next()#">
					<cfset process = processes.current() />
					<cfif process.number eq event.getArg('number')>
						<cfset selected = 'selected="selected"' />
					<cfelse>
						<cfset selected = '' />
					</cfif>
					<option value="#process.number#" #selected#>#process.number#</option>
				</cfloop>
			</select>
		</span>
		<span class="dropdown">
		<label for="board_chair_id">Board Chair</label>
			<select name="board_chair_id">
			<br />
			<option value="">All</option>
				<cfloop condition="#board_chairs.next()#">
					<cfset board_chair = board_chairs.current() />
					<cfif board_chair.id eq event.getArg('board_chair_id')>
						<cfset selected = 'selected="selected"' />
					<cfelse>
						<cfset selected = '' />
					</cfif>
					<option value="#board_chair.id#" #selected#>#board_chair.getName()#</option>
				</cfloop>
			</select>
		</span>
		<input name="search" type="submit" value="Search" class="submitButton"/>
	
	</fieldset>
</form>

</cfoutput>