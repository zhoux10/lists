class App.views.LayoutView extends Backbone.View
  initialize: (opts) ->
    @items = _.sortBy(opts.data, 'value')
    @render()

  events: ->
    'click .save-button': 'saveListOrder'
    'click .delete-button': 'deleteItem'
    'click .edit-button': 'editContents'
    'click .new-item': 'addNewItem'

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

  deleteItem: (event) ->
    item = event.currentTarget
    $.ajax({
          url : 'items/' + item.id,
          type : 'DELETE',
      });
    @$el.find('.item#' + item.id).remove()

  addNewItem: (event) ->
    button = event.currentTarget
    $form = @$el.find('.new-item-form')

    if $(button).text() == 'New Item'
      $(button).text('Save')
      $form.prepend('<input type="text" name="content" class="content" placeholder="Content">')
      $form.prepend('<input type="text" name="title" class="title" placeholder="Title">')
    else
      $title =  $form.find('.title')
      $content = $form.find('.content')

      $(button).text('New Item')
      contentValue = $content.val()
      titleValue = $title.val()
      that = this
      $.ajax({
            url : 'items',
            type : 'POST',
            data : {content: contentValue, title: titleValue, value: -1},
            success : (item)->
              itemView = new App.views.ItemView(item)
              that.$el.find('.main-list').prepend itemView.render()
        });

  editContents: (event) ->
    button = event.currentTarget
    $listItem = @$el.find('.item#' + button.id)
    $title =  $listItem.find('h2')
    $content = $listItem.find('p')
    if $(button).text() == 'Edit'
      $(button).text('Save')
      $title.html('<input type="text" name="title" value="' + $title.text() + '">')
      $content.html('<input type="text" name="content" value="' + $content.text()  + '">')
    else
      $(button).text('Edit')
      contentValue = $content.find('input').val()
      titleValue = $title.find('input').val()
      $.ajax({
            url : 'items/' + button.id,
            type : 'PATCH',
            data : {content: contentValue, title: titleValue},
            success : ->
              $title.text(titleValue)
              $content.text(contentValue)
        });
