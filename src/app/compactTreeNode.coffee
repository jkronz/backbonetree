class compactTree.CompactTreeNode extends Backbone.View
  tagName: 'li'

  events:
    'click > a.expand': 'triggerCurrentViewport'

  initialize: (options) ->
    @node = options.node
    @parent = options.parent
    @treeView = options.treeView
    @listenTo @treeView, 'compact-tree:updateViewport', @currentViewport
    @nameField = options.nameField
    @childViews = []

  currentViewport: (view) ->
    if view == @
      console.log(['@fragment', @fragment])
      @treeView.$el.html(@fragment)

  triggerCurrentViewport: (event) =>
    @treeView.trigger 'compact-tree:updateViewport', @
    event?.stopPropagation()
    event?.preventDefault()

  render: ->
    @$el.html(@template())
    @fragment = document.createDocumentFragment()
    _.each @node.children, (childNode) =>
      view = new compactTree.CompactTreeNode
        parent: @
        treeView: @treeView
        node: childNode
        nameField: @nameField
      @childViews.push(view)
      @fragment.appendChild(view.render().el)
    return this

  template: ->
    icon = if @node.allSelected
      "icon-check"
    else if @node.anySelected
      "icon-check-minus"
    else "icon-check-empty"
    if @node.children? && @node.children.length
      """
        <i class="#{icon}"></i>
        <a href="#" class="expand"> #{@node[@nameField]} <i class="icon-caret-right"></i></a>
        <ul class="children"></ul>
      """
    else
      """
        <i class="#{icon}"></i>
        #{@node[@nameField]}
      """