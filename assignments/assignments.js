(function() {

  $(function() {
    var Assignment, AssignmentList, AssignmentView, AssignmentsForm, AssignmentsTable, Process, ProcessList, form, table;
    Assignment = Backbone.Model.extend({
      url: '/pacific_renewal/applications/staffing/ws/createass.cfm',
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
    AssignmentView = Backbone.View.extend({
      tagName: 'tbody',
      template: Handlebars.templates['assignment'],
      events: {
        'click a.delete': 'delete'
      },
      "delete": function() {
        if (confirm('You sure?')) {
          this.model.destroy();
          this.model.clear();
          return this.$el.remove();
        }
      },
      render: function() {
        this.$el.html(this.template(this.model.toJSON()));
        return this;
      }
    });
    AssignmentsTable = Backbone.View.extend({
      tagName: 'table',
      initialize: function() {
        this.assignments = new AssignmentList;
        this.assignments.bind('reset', this.render, this);
        return this.assignments.fetch();
      },
      render: function() {
        this.assignments.each(function(a) {
          var view;
          view = new AssignmentView({
            model: a
          });
          return $('#assignments thead').after(view.render().el);
        });
        return this;
      }
    });
    AssignmentsForm = Backbone.View.extend({
      tagName: 'form',
      template: Handlebars.templates['form'],
      events: {
        'submit': 'submit'
      },
      initialize: function() {
        this.processes = new ProcessList;
        this.processes.bind('reset', this.render, this);
        return this.processes.fetch();
      },
      submit: function() {
        alert('balls');
        return false;
      },
      render: function() {
        this.$el.html(this.template({
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
    table = new AssignmentsTable({
      el: $('#assignments')
    });
    form = new AssignmentsForm();
    return $('#assignments').after(form.render().el);
  });

}).call(this);
