class App.views.ItemView extends Backbone.View
  initialize: (item, level) ->
    @item = item
    @children = this.childrenArray();
    @level = level

  events: ->
    'click >.delete-button': 'deleteItem'
    'click >.edit-button': 'editContents'
    'click >.hide-children': 'hideChildren'

  render: ->
    @template = HandlebarsTemplates['item'](@item)
    @$el.html(@template)
    @$childrenDiv = $('<ol class= "children-of-' + @item.id + ' level-' + @level + '" >')
    @$el.append(@$childrenDiv)

    if @children.length > 0
      @$el.find('>.hide-children').show()
    else
      @$el.find('>.hide-children').hide()

    for child in @children
      @$el.find('ol.children-of-' + @item.id).append(child.$el)
    @$el

  childrenArray: ->
    children = []
    if @item.children
      for child in @item.children
        itemView = new App.views.ItemView(child, @level + 1)
        itemView.render()
        children.push(itemView)

    _.sortBy(children, this.getValue)

  getValue: (view) ->
    view.item.value

  makeSortable: ->
    @$el.find('ol.children-of-' + @item.id).sortable({connectWith: '.level-' + @level})
    unless @children.length == 0
      for child in @children
        if child.makeSortable
          child.makeSortable()

  deleteItem: (event) ->
    $.ajax({
          url : 'items/' + @item.id,
          type : 'DELETE',
      });
    @$el.find('.item#' + @item.id).remove()


  editContents: (event) ->
    $button = $(event.currentTarget)
    $title =  @$el.find('>h2')
    $content = @$el.find('>p')
    if $button.text() == 'Edit'
      $button.text('Save')
      $title.html('<input type="text" name="title" value="' + $title.text() + '">')
      $content.html('<textarea name="content" >' + $content.text())
    else
      $button.text('Edit')
      contentValue = $content.find('textarea').val()
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
    if $button.text() == 'Hide Children'
      $button.text('Show Children')
      @$childrenDiv.hide();
    else
      $button.text('Hide Children')
      @$childrenDiv.show();
