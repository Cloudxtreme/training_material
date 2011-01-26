// Based on the example Backbone application contributed by
// [Jérôme Gravel-Niquet](http://jgn.me/).

// Load the application once the DOM is ready, using `jQuery.ready`:
$(function(){

  // Quiz Model
  // ----------

  window.Quiz = Backbone.Model.extend({

    parse: function(response){
      alert(JSON.stringify(response));
    }

  });

  window.QuizList = Backbone.Collection.extend({
    model: Quiz,
    url: '/quizzes',

    parse: function(response){
      // webmachine currently returns a list of quiz names
      // e.g. ["quiz_one", "quiz_two", "quiz_three"]
      // TODO: consider updating webmachine to return more info
      // e.g. [{"id":"quiz_one", "questions":[...]}]
      return _.map(response, function(path){
        return { id: path, content: path };
      });
    }

  });

  // Create our global collection of **Quizzes**.
  window.Quizzes = new QuizList;

  // Quiz View
  // --------------

  window.QuizView = Backbone.View.extend({

    tagName:  "li",

    // Cache the template function for a single item.
    template: _.template($('#item-template').html()),

    initialize: function() {
      this.model.view = this;
    },

    render: function() {
      $(this.el).html(this.template(this.model.toJSON()));
      this.setContent();
      return this;
    },

    setContent: function() {
      var content = this.model.get('content');
      this.$('.todo-content').text(content);
    }

  });

  // The Application
  // ---------------

  window.AppView = Backbone.View.extend({

    // Instead of generating a new element, bind to the existing skeleton of
    // the App already present in the HTML.
    el: $("#todoapp"),

    // At initialization we bind to the relevant events on the `Quizzes`
    // collection, when items are added or changed. Kick things off by
    // loading any preexisting todos that might be saved in *localStorage*.
    initialize: function() {
      _.bindAll(this, 'addOne', 'addAll', 'render');

      Quizzes.bind('refresh', this.addAll);
      Quizzes.bind('all',     this.render);

      Quizzes.fetch();
    },

    render: function() {
    },

    addOne: function(todo) {
      var view = new QuizView({model: todo});
      this.$("#todo-list").append(view.render().el);
    },

    addAll: function() {
      Quizzes.each(this.addOne);
    }

  });

  // Finally, we kick things off by creating the **App**.
  window.App = new AppView;

});
