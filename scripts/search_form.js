Event.observe(window, 'load', function() {
	getClassificationLevels();
	$('classification_id').observe('change', function() {
		getClassificationLevels();
	})

	$('search_form').observe('mouseover', mouseoverHandler);
	$('search_form').observe('mouseout', mouseoutHandler);
	$('search_form').observe('click', clickHandler);
	
	$('search_header').observe('click', function(e) {
		if(!$('search_fields').visible() ){
			clickHandler(e);
		}
		else{
			$('search_form').observe('mouseover', mouseoverHandler);
			$('search_form').observe('mouseout', mouseoutHandler);
			$('search_form').observe('click', clickHandler);
			$('search_fields').hide();
		}
		e.stop();
	});
});

function getClassificationLevels() {		
		var select_length = $('classification_level_id').options.length;	
		for (var i = select_length; i > 0; i--)
		{
			$('classification_level_id').remove(i);
		}
		
		$('classification_level_id').options[0].text = 'Loading...';
		
		new Ajax.Request('index.cfm?event=positions.get_classification_levels', {
			method: 'get',
			onSuccess: loadClassificationLevels,
			parameters: {
				classification_id: $('classification_id').getValue()
			}
		});
	}
		
	function loadClassificationLevels(transport, json) {		
		var selected_node = $('classification_level_id').options[0];
		for (var i = 0; i < json.data.name.length; i++)
		{
			var option_node = Builder.node('option', {value: json.data.id[i]}, json.data.name[i]);
			$('classification_level_id').appendChild(option_node)
			
			if (json.data.id[i] == $('current_classification_level_id').getValue())
			{
				selected_node = option_node;
			}
		}
		
		$('classification_level_id').options[0].text = 'All';
		selected_node.selected = true;
	}
		
function clickHandler(e) {
		$('search_header').removeClassName('hover');
		$('search_form').addClassName('open');
		$('search_fields').show();
		$('search_form').stopObserving('mouseover');
		$('search_form').stopObserving('mouseout');
		$('search_form').stopObserving('click');
		e.stop();
	}
	
	function mouseoverHandler(e) {
		$('search_form').addClassName('hover');
		$('search_header').addClassName('hover');
		e.stop();
	}
	
	function mouseoutHandler(e) {
		$('search_form').removeClassName('hover');
		$('search_form').removeClassName('open');
		$('search_header').removeClassName('hover');
		e.stop();
	}