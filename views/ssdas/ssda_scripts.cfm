<cfoutput>

<script>
	/* <[CDATA[ */

	// ---------------- START OF ONLOAD BEHAVIOUR ---------------- //

	Event.observe(window, 'load', function() {
		//
		// Make return to staffing log button work
		//

		if ($('return_to_log')) {
			$('return_to_log').observe('click', function() {
				window.location.href = '#request.path#index.cfm?event=positions.staffing_log';
			});
		}

		//
		// Setup all status select fields
		//
		$$('select.status').each(function(e) {
			e.observe('change', function(e) {
				setCompletionDate(e.element());
			});
		});

		//
		// Setup all estimated date fields
		//
		$$('input.estimated_date').each(function(e) {
			e.observe('change', function(e) {
				cascade(e.element());
			});
		});

		//
		// Setup all completion date fields
		//
		$$('input.completion_date').each(function(e) {
			e.observe('change', function(e) {
				setStatusToComplete(e.element());
			})
		});

		//
		// Setup behaviour for all 'Not Applicable' links
		//
		$$('a.delete_activity').each(function(e) {
			e.observe('click', function() {
				var confirmed = confirm('Are you sure you want to remove this activity from the SSDA?');
				if (confirmed)
				{
					deleteActivityRequest(this.id.substr(16))
				}
			})
		})

		//
		// Setup 'Add Activity' popup
		//
		if ($('add_activity'))
		{
			$('add_activity').observe('click', function() {
				dialog = Dialog.confirm(
					{
						url: "#request.path#views/activity_form.cfm?process_id=#event.getArg('process_id')#",
						options: {method: 'get'}
					},
					{
						className: "window",
						width: 600,
						okLabel: "Add Activity",
						onOk: addActivityRequest
					}
				);
			});
		}
	});

	// ---------------- END OF ONLOAD BEHAVIOUR ---------------- //

	function addActivityRequest() {
		var activity_id = $('activity_id').getValue();
		window.location.href = "#request.path#index.cfm?event=process.add_activity&process_id=#event.getArg('process_id')#&activity_id=" + activity_id;
	}

	function deleteActivityRequest(process_activity_id)
	{
		new Ajax.Request('#request.path#index.cfm?event=process.delete_activity', {
			method: 'get',
			onLoading: startLoading,
			onComplete: stopLoading,
			onSuccess: deleteActivityResponse,
			parameters: {
				process_activity_id: process_activity_id
			}
		});
	}

	function deleteActivityResponse(transport, json)
	{
		var activity_row = $('activity_' + json.PROCESS_ACTIVITY_ID);
		activity_row.remove();
	}

	function datePickerClosed(dateField)
	{
		if ($(dateField).hasClassName('estimated_date')) cascade(dateField);
		if ($(dateField).hasClassName('completion_date')) setStatusToComplete(dateField);
	}

	function cascade(dateField)
	{
		var result = confirm('Do you wish to adjust the dates for all subsequent activities by the same amount as this one?');
		if (result)
		{
			var original_date = Date.parseExact(previous_value, 'yyyy-MM-dd');
			var updated_date = Date.parseExact($(dateField).getValue(), 'yyyy-MM-dd');
			var span = new TimeSpan(updated_date - original_date);

			$(dateField).parentNode.parentNode.nextSiblings().each(function(e) {
				e.select('input.estimated_date').each(function(e) {
					old_date = Date.parseExact(e.getValue(), 'yyyy-MM-dd');
					if (old_date)
					{
						new_date = old_date.add(span.getTotalMilliseconds()).milliseconds();
						e.setValue(new_date.toString('yyyy-MM-dd'));
					}
					else
					{
						e.setValue(updated_date.toString('yyyy-MM-dd'));
					}
				});
			});
		}
	}

	function setStatusToComplete(dateField)
	{
		var status_select = dateField.parentNode.parentNode.select('select.status')[0];
		for (var i = 0; i < status_select.options.length; i++)
		{
			if (status_select.options[i].innerHTML == 'Completed') status_select.options[i].selected = true
		}
	}

	function setCompletionDate(statusField)
	{
		var completion_date = statusField.parentNode.parentNode.select('input.completion_date')[0];
		if (statusField.options[statusField.selectedIndex].text == 'Completed')
		{
			completion_date.setValue(Date.today().toString('yyyy-MM-dd'));
		}
		else
		{
			completion_date.setValue('');
		}
	}

	/* ]]> */
</script>

<cffunction name="editable_date" access="public" returntype="void" output="true">
	<cfargument name="field" type="string" required="yes" />
	<cfargument name="id" type="numeric" required="yes" />
	<cfargument name="value" type="string" required="yes" />

	<div id="#arguments.field#_#arguments.id#" class="#arguments.field#">
		<span class="editable">
			<a><img src="#request.path#images/edit_icon.gif" /></a>
			<a id="#arguments.field#_value_#arguments.id#">
				<cfif arguments.value EQ "">
					-----
				<cfelse>
					#DateFormat(arguments.value, 'yyyy-MM-dd')#
				</cfif>
			</a>
		</span>
		<div style="display: none;">
			<input id="#arguments.field#_input_#id#" type="text" value="#DateFormat(arguments.value, 'yyyy-MM-dd')#" style="width: auto;" />
			<img style="cursor: pointer;" src="#request.path#images/calendar.gif" alt="Calendar" class="calendar" />
			<a class="okLink">Ok</a>
			<a class="cancelLink">Cancel</a>
		</div>
	</div>
</cffunction>

</cfoutput>
