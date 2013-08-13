window.compactTree = {}
class compactTree.CompactTree extends Backbone.View
  tagName: 'ul'
  className: 'compact-tree'
  initialize: (options) ->
    @tree = options.tree
    @childViews = []
    @nameField = options.nameField
    if typeof options.selected == "string"
      @_selected = (node) ->
        node[options.selected]
    else
      @_selected = options.selected
    @calculateSelected(@tree, null)

  render: ->
    view = new compactTree.CompactTreeNode
      node: @tree
      parent: null
      nameField: @nameField
      treeView: @
    @childViews.push(view)
    view.render()
    view.currentViewport(view)
    return this

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
        node.anySelected = _.any(childrenSelected)
        node.allSelected = node.anySelected && _.all(childrenSelected)
    else
      node.allSelected = (parent? && parent.allSelected) || @_selected(node)
    return node.allSelected

  remove: ->
    _.each @childViews, (vw) ->
      vw.remove()
    super()



