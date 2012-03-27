
  $(function() {
    $(".datepicker").datepicker({
      showOn: "button",
      dateFormat: 'yy-mm-dd',
      buttonText: 'Calendar'
    });
    $('#create').submit(function() {
      if ($('#expiry_date').val().length !== 10) {
        return alert('Must enter a valid date');
      } else {
        return $.post('create.cfm', $(this).serialize());
      }
    });
    $('a.delete').click(function() {
      if (confirm('You sure?')) {
        return $.post('delete.cfm', {
          id: $(this).closest('tr').id
        });
      }
    });
    return $('#process_template');
  });
