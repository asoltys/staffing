/* <[CDATA[ */

var selection_mode = false;
var loading_mode= false;
var positions = '';
var header_row = '';

Event.observe(window, 'load', function() {
	$$('tr.detailsToggle').each(function(e) { 
		e.observe('click', function(e) {
			if (selection_mode) {
				selectRow(e.element())
			}
			else {
				if(!loading_mode)
					toggleDetails(e.element());
			}
		})
		
		e.style.cursor = 'pointer';
		if (navigator.appName == "Microsoft Internet Explorer") 
		{
			e.observe('mouseover', function() {
				e.className += ' IEhover';
			});
			e.observe('mouseout', function() {
				e.className = e.className.replace(" IEhover","");
				
			});
		}
	})
	
	if ($('expandAll') && $('collapseAll'))
	{
		$('expandAll').observe('click', expandAll)
		$('collapseAll').observe('click', collapseAll)
	}
	
	$$('table#positions th a').each(function(a) {
		a.observe('click', function(e) {
			$('order_by').select('option').each(function(o) {
				if (o.innerHTML == a.innerHTML) o.selected = true;
			})
			
			if ($('direction').options[0].selected) {
				$('direction').options[1].selected = true
			}
			else {
				$('direction').options[0].selected = true
			}
			
			$('search_form').submit();
		})
	});
	
	if ($('assign_staff')) {
		$('assign_staff').observe('click', function(e) {
				// If we've just finished selecting positions then it's time to select some users
				if (selection_mode) {
					displayUserSelectionDialog();
				}
				else {
					alert('Select positions by clicking on them.  When finished, click the \'Finish Selecting Positions\' link.  Wait for the user selection screen to appear.');
					selection_mode = true;
					$('assign_staff').update('Finish Selecting Positions');
				}
		});
	}
});

function displayUserSelectionDialog() {
	selection_mode = false;
	dialog = Dialog.confirm( 
		{ 
			url: "index.cfm?event=positions.list",
			options: {
				method: 'get',
				parameters: {
					positions: positions
				}
			}
		},
		{ 
			className: "window",
			width: 600,
			okLabel: "Update",
			onOk: assignUsers,
			onCancel: function() { $('assign_staff').update('Manage Position Assignments'); $$('tr.selected').invoke('removeClassName', 'selected'); }
		}
	);
}

function assignUsers() {
	$('assignment_form').submit();
}

function selectRow(e) {
	var header_row = e.parentNode;
	header_row.toggleClassName('selected');
	positions.replace(header_row.id.substr(7) + ',', '');
	
	if (header_row.hasClassName('selected')) {
		positions += header_row.id.substr(7) + ',';
	}
}

function toggleDetails(e)
{
  header_row = e.parentNode
	row_id= header_row.getAttribute('id');
	process_id = header_row.id.substr(7);
	
	if ($('details_' + process_id)) {
		removeDetails();
  	} else {
  		loading_mode = true;
	  	/* This is where we do our AJAX */
	  	new Ajax.Request("index.cfm?event=positions.details", {
		method: 'get',
		onSuccess: insertDetails,
		parameters: {
			id: process_id
		}
	  });
	}
}


function insertDetails(transport)
{
  var detailRow = new Element('tr', {id: 'details_' + process_id}).insert(new Element('td', {colspan: '6'}).update(transport.responseText));
  $('toggle_' + process_id).insert({after: detailRow});
  loading_mode = false;
}

function removeDetails()
{
  $('details_' + process_id).remove();
}

function expandAll(e)
{
	$$('tr.detailsToggle').each(function(e) {
		details_row = $('details_' + e.id.substr(7))
		if (navigator.appName == "Microsoft Internet Explorer") 
		{
			details_row.style.display = 'block';
		}
		else
		{
			details_row.style.display = 'table-row';
		}
	})
}

function collapseAll(e)
{
	$$('tr.detailsToggle').each(function(e) {
		details_row = $('details_' + e.id.substr(7))
		details_row.style.display = 'none';
	})
}


/* ]]> */
