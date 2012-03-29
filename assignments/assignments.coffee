$(->
  Assignment = Backbone.Model.extend(
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
  )

  AssignmentsView = Backbone.View.extend(
    template: Handlebars.templates['assignments.template']

    initialize: ->
      this.assignments = new AssignmentList
      this.assignments.bind('reset', this.render, this)
      this.assignments.fetch()

    render: ->
      $('#assignments-container').html(this.template(assignments: this.assignments.toJSON()))
      return this
  )

  AssignmentForm = Backbone.View.extend(
    tagName: 'form'
    template: Handlebars.compile($('#assignment-form').html())

    initialize: ->
      this.processes = new ProcessList
      this.$('.datepicker').datepicker(
        showOn: "button"
        dateFormat: 'yy-mm-dd'
        buttonText: 'Calendar'
      )

    events:
      "click a.delete" : "delete"

    delete: ->
      if confirm('You sure?')
        this.model.destroy()

    render: ->
      this.$el.html(this.template(this.processes.toJSON()))
      return this

    submit: ->
      assignment.save()
  )

  view = new AssignmentsView
)
