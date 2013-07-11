window.backstraptree = {}
class backstraptree.TreeView extends Backbone.View
  initialize: (options) =>
    @tree = options.tree
    @nameField = options.nameField || 'name'
    @showLeaves = options.showLeaves || false
    @listenTo Backbone, 'backstraptree:selection_updated', @updateCount

  render: =>
    @root = new backstraptree.TreeNode
      node: @tree
      nameField: @nameField
      showLeaves: @showLeaves
    @$el.html(@root.render().el)
    return this

  updateCount: =>
    selectedNodes = @collectCheckedNodes()

  collectCheckedNodes: =>
    @root.collectCheckedNodes([])

