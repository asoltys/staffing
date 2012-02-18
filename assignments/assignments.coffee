$(->
  $(".datepicker").datepicker({
    showOn: "button",
    dateFormat: 'mm/dd/yy',
    buttonText: 'Calendar'
  })

  $('#create').submit(->
    $.post('create.cfm', $(this).serialize())
    $('#actings').append("<tr><td>#{$('#process_id').
    return false
  )
)
