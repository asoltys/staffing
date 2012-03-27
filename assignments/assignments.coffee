$(->
  $(".datepicker").datepicker({
    showOn: "button",
    dateFormat: 'yy-mm-dd',
    buttonText: 'Calendar'
  })

  $('#create').submit(->
    if $('#expiry_date').val().length != 10
      alert('Must enter a valid date')
    else
      $.post('create.cfm', $(this).serialize())
  )

  $('a.delete').click(->
    if confirm('You sure?')
      $.post('delete.cfm', {id: $(this).closest('tr').id})
  )

  $('#process_template')
)
