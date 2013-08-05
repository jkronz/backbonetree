window.statictree = {}
class statictree.StaticTree extends Backbone.View
  tagName: 'ul'
  className: 'backbonetree static'

  initialize: (options) =>
    @tree = options.tree
    @nameField = options.nameField || 'name'
    @showLeaves = options.showLeaves || false
    @selected = options.selected || =>
      return false
    if typeof @selected == "function"
      @_selected = @selected
    else
      @_selected = (node) =>
        return node[@selected]
    @childViews = []
    @initializeTree(@tree)

  initializeTree: (node) =>
    selectedNode = @_selected(node)
    if selectedNode
      node.show = true
      return true
    else if node.children? && node.children.length
      selectedList = _.map node.children, (childNode) =>
        #recurse. if any descendants are selected, this node is too.
        @initializeTree(childNode)
      anySelected = _.any selectedList
      node.show = anySelected
      return anySelected
    else
      node.show = false
      return false

  render: =>
    @removeChildren()
    @topNode = new statictree.StaticTreeNode
      node: @tree
      nameField: @nameField
    @$el.html(@topNode.render().el)
    return this

  removeChildren: =>
    @topNode?.remove()

  remove: =>
    @removeChildren()
    @stopListening()
    @undelegateEvents()
    super()