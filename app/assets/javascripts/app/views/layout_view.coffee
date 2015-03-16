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
    $button = $(event.currentTarget)
    $form = @$el.find('.new-item-form')

    if $button.text() == 'New Item'
      $button.text('Save')
      $form.prepend(this.parentOptions())
      $form.prepend('<input type="text" name="content" class="content" placeholder="Content">')
      $form.prepend('<input type="text" name="title" class="title" placeholder="Title">')
    else
      $title =  $form.find('.title')
      $content = $form.find('.content')
      $parent = $form.find('.parent')

      $button.text('New Item')
      parentValue = $parent.val()
      contentValue = $content.val()
      titleValue = $title.val()
      that = this
      $.ajax({
            url : 'items',
            type : 'POST',
            data : {parent_id: parentValue, content: contentValue, title: titleValue, value: -1},
            success : (item)->
              $form.html($button)
              itemView = new App.views.ItemView(item)
              if parentValue
                that.$el.find('.children-of-' + parentValue).prepend itemView.render()
                that.$el.find('.item#' + parentValue + ' >.hide-children').show()
              else
                that.$el.find('.main-list').prepend itemView.render()
        });

  parentOptions: ->
    $container = $('<select class="parent">')
    $container.append('<option value="">Choose parent list')
    for child in @children
      $container.append('<option value=' + child.id + '>' + child.item.title)
    $container
