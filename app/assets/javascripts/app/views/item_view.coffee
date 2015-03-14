class App.views.ItemView extends Backbone.View
  initialize: (item) ->
    @item = item

  render: ->
    HandlebarsTemplates['item'](@item)