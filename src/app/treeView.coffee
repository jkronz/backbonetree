window.backstraptree = {}
class backstraptree.TreeView extends Backbone.View
  initialize: (options) =>
    @tree = options.tree
    @nameField = options.nameField || 'name'
    @showLeaves = options.showLeaves || false

  render: =>
    root = new backstraptree.TreeNode
      node: @tree
      nameField: @nameField
      showLeaves: @showLeaves
    @$el.html(root.render().el)
    return this


