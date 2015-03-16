class App.views.LayoutView extends Backbone.View
  initialize: (opts) ->
    @items = _.sortBy(opts.data, 'value')
    @children = []
    @render()

  events: ->
    'click .save-button': 'saveListOrder'
    'click .new-item': 'addNewItem'

  render: ->
    @$el.html HandlebarsTemplates['layout']()

    for item in @items
      itemView = new App.views.ItemView(item)
      @$el.find('.main-list').append itemView.render()
      @children.push(itemView)

    this.$('.main-list').sortable()
    this.onRender()

  onRender: ->
    for child in @children
      child.onRender()

  saveListOrder: (event) ->
    for item, value in @$el.find('.item')
      $.ajax({
            url : 'items/' + item.id,
            type : 'PATCH',
            data : {value: value},
        });

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
