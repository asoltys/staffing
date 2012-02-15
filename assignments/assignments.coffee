$(->
  $(".datepicker").datepicker({
    showOn: "button",
    dateFormat: 'mm/dd/yy',
    buttonText: 'Calendar'
  })

  $('#create').submit(->
    $.post('create.cfm', $(this).serialize(), assignments)
    return false
  )
  
  assignments = ->
    $.getJSON('list.cfm', (json) ->
      $.each(json.data.number, (i, v) ->
        $('#actings').after(v)
      )
    )
)
