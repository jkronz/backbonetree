class statictree.StaticTreeNode extends Backbone.View
  tagName: 'li'
  className: 'node collapsed'

  events:
    'click > a.expand': 'expand'

  initialize: (options) =>
    @node = options.node
    @nameField = options.nameField || 'name'
    @childViews = []

  render: =>
    @$el.html(@template())
    node = document.createDocumentFragment()
    _.each @children(), (child) =>
      childView = new statictree.StaticTreeNode
        node: child
        nameField: @nameField
      @childViews.push(childView)
      node.appendChild(childView.render().el)
    @$('.children').html(node)
    return this

  children: =>
    if @_children then return @_children
    @childrenMemo = _.filter @node.children, (child) =>
      child.show

  expand: (event) =>
    if @$el.is(".collapsed")
      @$el.removeClass('collapsed')
    else
      @$el.addClass('collapsed')
    event?.stopPropagation()
    event?.preventDefault()

  template: =>
    if @children().length > 0
      """
        <a href="#" class="expand">
          <i class="icon-expand-alt"></i>
          <i class="icon-collapse-alt"></i>
        </a>
        <label class="checkbox">#{@node[@nameField]}</label>
        <ul class="children"></ul>
      """
    else
      """
      <label class="checkbox">#{@node[@nameField]}</label>
      """

  removeChildren: =>
    _.each @childViews, (view) =>
      view.remove()

  remove: =>
    @removeChildren()
    @stopListening()
    @undelegateEvents()
    super()