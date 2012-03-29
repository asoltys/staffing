(function() {

  $(function() {
    var Assignment, AssignmentList, AssignmentsView, Process, ProcessList, view;
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
      model: Process,
      url: '/pacific_renewal/applications/staffing/ws/processes.cfm'
    });
    AssignmentsView = Backbone.View.extend({
      tagName: 'div',
      template: Handlebars.templates['assignments.template'],
      events: {
        "click a.delete": "delete",
        "submit form": "submit"
      },
      initialize: function() {
        this.$el = $('#assignments-container');
        this.assignments = new AssignmentList;
        this.assignments.bind('reset', this.render, this);
        this.assignments.fetch();
        this.processes = new ProcessList;
        this.processes.bind('reset', this.render, this);
        return this.processes.fetch();
      },
      submit: function() {
        assignment.save();
        return false;
      },
      "delete": function() {
        if (confirm('You sure?')) return this.model.destroy();
      },
      render: function() {
        $('#assignments-container').html(this.template({
          assignments: this.assignments.toJSON(),
          processes: this.processes.toJSON()
        }));
        $('.datepicker').datepicker({
          showOn: "button",
          dateFormat: 'yy-mm-dd',
          buttonText: 'Calendar'
        });
        return this;
      }
    });
    return view = new AssignmentsView;
  });

}).call(this);
