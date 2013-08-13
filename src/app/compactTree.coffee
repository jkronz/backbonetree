window.compactTree = {}
class compactTree.CompactTree extends Backbone.View
  className: 'compact-tree'

  events:
    'click .back': 'showParent'

  initialize: (options) ->
    @tree = options.tree
    @childViews = []
    @nameField = options.nameField
    @listenTo @, 'compact-tree:updateViewport', @refreshViewport
    if typeof options.selected == "string"
      @_selected = (node) ->
        node[options.selected]
    else
      @_selected = options.selected
    @calculateSelected(@tree, null)

  render: ->
    @root = new compactTree.CompactTreeNode
      node: @tree
      parent: null
      nameField: @nameField
      treeView: @
    @childViews.push(@root)
    @root.render()
    @$el.html(@template())
    @refreshViewport(null)
    return this

  showParent: (event) =>
    @refreshViewport(@currentView.parent)
    event?.stopPropagation()
    event?.preventDefault()

  refreshViewport: (@currentView) =>
    if @currentView?
      @$('.back').show()
      @$('.tree-items').html(@currentView.childMarkup())
    else
      @$('.tree-items').html(@root.el)
      @root.delegateEvents()
      @$('.back').hide()

  calculateSelected: (node, parent) =>
    if node.children? && node.children.length > 0
      if (parent? && parent.allSelected) || @_selected(node)
        node.allSelected = true
        #if node is selected, traverse down setting descendants true
        _.each node.children, (child) =>
          @calculateSelected(child, node)
      else
        childrenSelected = _.map node.children, (child) =>
          @calculateSelected(child, node)
        any = _.any(childrenSelected)
        node.anySelected = any || _.any node.children, (child) =>
          child.anySelected
        node.allSelected = any && _.all(childrenSelected)
    else
      node.allSelected = (parent? && parent.allSelected) || @_selected(node)
    return node.allSelected

  remove: ->
    _.each @childViews, (vw) ->
      vw.remove()
    @stopListening()
    @undelegateEvents()
    super()

  template: =>
    """
    <a class="back" href="#"><i class="icon-caret-left"></i> Back</a>
    <ul class="tree-items"></ul>
    """



