class App.views.LayoutView extends Backbone.View
  initialize: (opts) ->
    @items = _.sortBy(opts.data, 'value')
    @render()

  events: ->
    'click .save-button': 'saveListOrder'

  render: ->
    @$el.html HandlebarsTemplates['layout']()

    for item in @items
      itemView = new App.views.ItemView(item)
      @$el.find('.main-list').append itemView.render()
    this.$('.main-list').sortable()

  saveListOrder: (event) ->
    for item, value in @$el.find('.item')
      $.ajax({
            url : 'items/' + item.id,
            type : 'PATCH',
            data : {value: value},
        });
