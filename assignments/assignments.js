
  $(function() {
    var Assignment, AssignmentForm, AssignmentList, AssignmentsView, Process, ProcessList, view;
    Assignment = Backbone.Model.extend({
      validate: function() {
        return this.get('expiry_date').length === 10;
      }
    });
    Process = Backbone.Model.extend();
    AssignmentList = Backbone.Collection.extend({
      model: Assignment,
      url: '/pacific_renewal/applications/staffing/ws/assignments.cfm'
    });
    ProcessList = Backbone.Collection.extend({
      model: Process
    });
    AssignmentsView = Backbone.View.extend({
      template: Handlebars.templates['assignments.template'],
      initialize: function() {
        this.assignments = new AssignmentList;
        this.assignments.bind('reset', this.render, this);
        return this.assignments.fetch();
      },
      render: function() {
        $('#assignments-container').html(this.template({
          assignments: this.assignments.toJSON()
        }));
        return this;
      }
    });
    AssignmentForm = Backbone.View.extend({
      tagName: 'form',
      template: Handlebars.compile($('#assignment-form').html()),
      initialize: function() {
        this.processes = new ProcessList;
        return this.$('.datepicker').datepicker({
          showOn: "button",
          dateFormat: 'yy-mm-dd',
          buttonText: 'Calendar'
        });
      },
      events: {
        "click a.delete": "delete"
      },
      "delete": function() {
        if (confirm('You sure?')) return this.model.destroy();
      },
      render: function() {
        this.$el.html(this.template(this.processes.toJSON()));
        return this;
      },
      submit: function() {
        return assignment.save();
      }
    });
    return view = new AssignmentsView;
  });
