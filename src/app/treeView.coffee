window.backstraptree = {}
class backstraptree.TreeView extends Backbone.View
  initialize: (options) =>
    @tree = options.tree
    @nameField = options.nameField || 'name'

  render: =>
    root = new backstraptree.TreeNode
      node: @tree
      nameField: @nameField
    @$el.html(root.render().el)
    return this


