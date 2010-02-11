Event.observe(window, 'load', function() {
  $('region_id').observe('change', function() {
    $('region_form').submit();
  });
});
