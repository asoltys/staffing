<cfoutput>

<cfset classification = position.job.classification_level.classification.name />
<cfset classification_level = position.job.classification_level.name />
<cfset branch = position.job.branch />

<script>
	/* <[CDATA[ */

	Event.observe(window, 'load', function() {
		$('title').observe('change', function() {
			getClassifications()
		})
		
		$('classification').observe('change', function() {
			getClassificationLevels()
		})
		
		$('classification_level').observe('change', function() {
			getBranches()
		})
		
		$('branch').observe('change', function() {
			getJobID()
		})
		
		getClassifications();
	});
	
	function getClassifications() {
		clearOptions($('classification'));
		clearOptions($('classification_level'));
		clearOptions($('branch'));
		
		displayLoading($('classification'));
		
		new Ajax.Request('#request.path#index.cfm?event=jobs.get_classifications', {
			method: 'get',
			onSuccess: loadClassifications,
			parameters: {
				title: $('title').getValue()
			}
		});
	}
		
	function loadClassifications(transport, json) {
		var selected_node = $('classification').options[0];
		
		json.data.name.each(function(classification) {
			var option_node = Builder.node('option', {value: classification}, classification);
			
			if ((classification == '#classification#')) {
				selected_node = option_node;
			}
			
			$('classification').appendChild(option_node)
		})
		
		selected_node.selected = true;
		
		if (selected_node.value != '')
		{
			getClassificationLevels();
		}
		
		hideLoading($('classification'));
	}
	
	function getClassificationLevels() {
		clearOptions($('classification_level'));
		clearOptions($('branch'));
		
		displayLoading($('classification_level'));
		
		new Ajax.Request('#request.path#index.cfm?event=jobs.get_classification_levels', {
			method: 'get',
			onSuccess: loadClassificationLevels,
			parameters: {
				classification: $('classification').getValue(),
				title: $('title').getValue()
			}
		});
	}
		
	function loadClassificationLevels(transport, json) {
		var selected_node = $('classification_level').options[0];
		
		json.data.name.each(function(classification_level) {
			var option_node = Builder.node('option', {value: classification_level}, classification_level);
			
			if ((classification_level == '#classification_level#')) {
				selected_node = option_node;
			}
			
			$('classification_level').appendChild(option_node)
		})
		
		selected_node.selected = true;

		if (selected_node.value != '')
		{
			getBranches();
		}
		
		hideLoading($('classification_level'));
	}
	
	function getBranches() {
		clearOptions($('branch'));
		
		displayLoading($('branch'));
		
		new Ajax.Request('#request.path#index.cfm?event=jobs.get_branches', {
			method: 'get',
			onSuccess: loadBranches,
			parameters: {
				title: $('title').getValue(),
				classification: $('classification').getValue(),
				classification_level: $('classification_level').getValue()
			}
		});
	}
	
	function loadBranches(transport, json) {
		var selected_node = $('branch').options[0];
		
		json.data.branch.each(function(branch) {
			var option_node = Builder.node('option', {value: branch}, branch);
			
			if ((branch == '#branch#')) {
				selected_node = option_node;
			}
			
			$('branch').appendChild(option_node)			
		})
		
		selected_node.selected = true;
		
		if (selected_node.value != '')
		{
			getJobID();
		}
		
		hideLoading($('branch'));
	}
	
	function getJobID() {
		new Ajax.Request('#request.path#index.cfm?event=jobs.get_job_id', {
			method: 'get',
			onSuccess: loadJobID,
			parameters: {
				title: $('title').getValue(),
				classification: $('classification').getValue(),
				classification_level: $('classification_level').getValue(),
				branch: $('branch').getValue()
			}
		});
	}
	
	function loadJobID(transport, json) {
		$('job_id').setValue(json.data.id[0]);
	}
	
	function clearOptions(select_field) {
		var select_length = select_field.options.length;
		
		for (var i = select_length; i > 0; i--)
		{
			select_field.remove(i);
		}
	}
	
	function displayLoading(select_field) {
		select_field.options[0].text = 'Loading...';
	}
	
	function hideLoading(select_field) {
		select_field.options[0].text = 'Select One';
	}

	/* ]]> */
</script>

</cfoutput>