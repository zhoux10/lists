class App.views.ItemView extends Backbone.View
  initialize: (item) ->
    @item = item
    @children = this.attachChildren();

  render: ->
    @template = HandlebarsTemplates['item'](@item)
    @$el.html(@template)
    @$el.append('<ol class= "children-of-' + @item.id + '" >')
    for child in @children
      @$el.find('ol.children-of-' + @item.id).append(child[0].$el)
    @$el

  attachChildren: ->
    children = []
    for child in @item.children
      itemView = new App.views.ItemView(child)
      children.push([itemView, itemView.render()])

    children

  onRender: ->
    @$el.find('ol.children-of-' + @item.id).sortable()
    unless @children.length == 0
      for child in @children
        if child[0].onRender
          child[0].onRender()
