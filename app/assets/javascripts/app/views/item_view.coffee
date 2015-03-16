class App.views.ItemView extends Backbone.View
  initialize: (item) ->
    @item = item
    @children = this.attachChildren();

  events: ->
    'click .delete-button': 'deleteItem'
    'click .edit-button': 'editContents'
    'click .hide-children': 'hideChildren'

  render: ->
    @template = HandlebarsTemplates['item'](@item)
    @$el.html(@template)
    @$childrenDiv = $('<ol class= "children-of-' + @item.id + '" >')
    @$el.append(@$childrenDiv)

    if @children.length > 0
      @$el.find('h2').prepend('<button class="hide-children">-</button>')

    for child in @children
      @$el.find('ol.children-of-' + @item.id).append(child[0].$el)
    @$el

  attachChildren: ->
    children = []
    if @item.children
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

  deleteItem: (event) ->
    $.ajax({
          url : 'items/' + @item.id,
          type : 'DELETE',
      });
    @$el.find('.item#' + @item.id).remove()


  editContents: (event) ->
    button = event.currentTarget
    $title =  @$el.find('h2')
    $content = @$el.find('p')
    if $(button).text() == 'Edit'
      $(button).text('Save')
      $title.html('<input type="text" name="title" value="' + $title.text() + '">')
      $content.html('<input type="text" name="content" value="' + $content.text()  + '">')
    else
      $(button).text('Edit')
      contentValue = $content.find('input').val()
      titleValue = $title.find('input').val()
      $.ajax({
            url : 'items/' + @item.id,
            type : 'PATCH',
            data : {content: contentValue, title: titleValue},
            success : ->
              $title.text(titleValue)
              $content.text(contentValue)
        });

  hideChildren: (event) ->
    $button = $(event.currentTarget)
    if $button.text() == '-'
      $button.text('+')
      @$childrenDiv.hide();
    else
      $button.text('-')
      @$childrenDiv.show();
