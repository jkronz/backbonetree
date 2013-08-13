class compactTree.CompactTreeNode extends Backbone.View
  tagName: 'li'

  events:
    'click > a.expand': 'triggerCurrentViewport'

  initialize: (options) ->
    @node = options.node
    @parent = options.parent
    @treeView = options.treeView
    @nameField = options.nameField
    @childViews = []

  triggerCurrentViewport: (event) =>
    @treeView.trigger 'compact-tree:updateViewport', @
    event?.stopPropagation()
    event?.preventDefault()

  render: =>
    @$el.html(@template())
    @delegateEvents()
    _.each @node.children, (childNode) =>
      view = new compactTree.CompactTreeNode
        parent: @
        treeView: @treeView
        node: childNode
        nameField: @nameField
      @childViews.push(view.render())
    return this

  childMarkup: =>
    fragment = document.createDocumentFragment()
    _.each @childViews, (vw) =>
      fragment.appendChild(vw.el)
      vw.delegateEvents()
    fragment

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
      """
    else
      """
        <i class="#{icon}"></i>
        #{@node[@nameField]}
      """

  closeChildren: =>
    _.each @childViews, (vw) =>
      vw.remove()

  remove: =>
    @closeChildren()
    @undelegateEvents()
    @stopListening()
    super()