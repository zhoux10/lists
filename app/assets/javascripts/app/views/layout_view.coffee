class App.views.LayoutView extends Backbone.View
  initialize: (opts) ->
    @items = opts.data
    @render()

  render: ->
    @$el.html HandlebarsTemplates['layout']()

    for item in @items
      itemView = new App.views.ItemView(item)
      @$el.find('.main-list').append itemView.render()
