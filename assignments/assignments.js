
  $(function() {
    var assignments;
    $(".datepicker").datepicker({
      showOn: "button",
      dateFormat: 'mm/dd/yy',
      buttonText: 'Calendar'
    });
    $('#create').submit(function() {
      $.post('create.cfm', $(this).serialize(), assignments);
      return false;
    });
    return assignments = function() {
      return $.getJSON('list.cfm', function(json) {
        return $.each(json.data.number, function(i, v) {
          return $('#actings').after(v);
        });
      });
    };
  });
