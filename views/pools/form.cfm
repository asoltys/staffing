<cfset pool = event.getArg('pool') />
<cfset processes = event.getArg('processes') />
<cfset contacts = event.getArg('contacts') />
<cfset classification_levels = event.getArg('classification_levels') />
<cfset errors = event.getArg('errors') />

<cfinclude template="#request.includes_path#includes/helpers.cfm">

<cfoutput>

<h1>Pool</h1>

<cfinvoke method="displayErrors" />

<form action="index.cfm?event=pools.process" method="post">
	<input id="id" name="id" type="hidden" value="#pool.id#" />

	<label for="process_id">Process Number:</label>
	<select id="process_id" name="process_id">
		<option value="">Select One</option>
		<cfloop condition="#processes.next()#">
			<cfset process = processes.current() />

			<cfset selected = "" />
			<cfif process.id EQ pool.process_id>
				<cfset selected = "selected=""selected""" />
			</cfif>

			<option value="#process.id#" #selected#>#process.number#</option>
		</cfloop>
	</select>

	<br /><br />

	<label for="contact_id">Contact Person:</label>
	<select id="contact_id" name="contact_id">
		<option value="">Select One</option>
		<cfloop condition="#contacts.next()#">
			<cfset contact = contacts.current() />

			<cfset selected = "" />
			<cfif contact.id EQ pool.contact_id>
				<cfset selected = "selected=""selected""" />
			</cfif>

			<option value="#contact.id#" #selected#>#contact.getName()#</option>
		</cfloop>
	</select>

	<br /><br />

	<label for="classification_level_id">Classification / Level:</label>
	<select id="classification_level_id" name="classification_level_id">
		<option value="">Select One</option>
		<cfloop condition="#classification_levels.next()#">
			<cfset classification_level = classification_levels.current() />

			<cfset selected = "" />
			<cfif classification_level.id EQ pool.classification_level_id>
				<cfset selected = "selected=""selected""" />
			</cfif>

			<option value="#classification_level.id#" #selected#>#classification_level.classification.name# #classification_level.name#</option>
		</cfloop>
	</select>

	<br /><br />

	<label for="expiry_date">Expiry Date <small>(yyyy-mm-dd)</small>:</label>
	<input id="expiry_date" name="expiry_date" type="text" value="#LSDateFormat(pool.expiry_date, "yyyy-mm-dd")#" class="date" />
	<img src="#request.path#images/calendar.gif" class="calendar" />

	<br /><br />

	<label for="description">Description:</label>
	<textarea id="description" name="description">#pool.description#</textarea>

	<br /><br />

	<input type="submit" name="submit_button" id="submit_button" value="Save" class="submitButton"/>
</form>

</cfoutput>