$(->
  Assignment = Backbone.Model.extend(
    url: '/pacific_renewal/applications/staffing/ws/createass.cfm'
    validate: ->
      this.get('expiry_date').length == 10
  )

  Process = Backbone.Model.extend(
  )

  AssignmentList = Backbone.Collection.extend(
    model: Assignment
    url: '/pacific_renewal/applications/staffing/ws/assignments.cfm'
  )

  ProcessList = Backbone.Collection.extend(
    model: Process
    url: '/pacific_renewal/applications/staffing/ws/processes.cfm'
  )

  AssignmentView = Backbone.View.extend(
    tagName: 'tbody'
    template: Handlebars.templates['assignment']
    events: 'click a.delete' : 'delete'

    delete: ->
      if confirm('You sure?')
        this.model.destroy()
        this.model.clear()
        this.$el.remove()

    render: ->
      this.$el.html(this.template(
        this.model.toJSON()
      ))
      return this
  )

  AssignmentsTable = Backbone.View.extend(
    tagName: 'table'

    initialize: ->
      this.assignments = new AssignmentList
      this.assignments.bind('reset', this.render, this)
      this.assignments.fetch()

    render: ->
      this.assignments.each((a) -> 
        view = new AssignmentView(model: a)
        $('#assignments thead').after(view.render().el)
      ) 
      return this
  )

  AssignmentsForm = Backbone.View.extend(
    tagName: 'form'
    template: Handlebars.templates['form']
    events: 'submit': 'submit'

    initialize: ->
      this.processes = new ProcessList
      this.processes.bind('reset', this.render, this)
      this.processes.fetch()

    submit: ->
      alert('balls')
      return false

    render: ->
      this.$el.html(this.template(
        processes: this.processes.toJSON()
      ))

      $('.datepicker').datepicker(
        showOn: "button"
        dateFormat: 'yy-mm-dd'
        buttonText: 'Calendar'
      )

      return this
  )

  table = new AssignmentsTable(el: $('#assignments'))
  form = new AssignmentsForm()
  $('#assignments').after(form.render().el)
)
