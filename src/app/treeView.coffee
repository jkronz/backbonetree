window.backbonetree = {}
class backbonetree.TreeView extends Backbone.View
  tagName: 'ul'
  className: 'backbonetree'

  initialize: (options) =>
    @tree = options.tree
    @nameField = options.nameField || 'name'
    @showLeaves = options.showLeaves || false
    @readOnly = options.readOnly || false
    @selected = options.selected || =>
      return false
    @childViews = []

  render: =>
    # i dont care to display the root element.
    @removeChildren()
    elem = document.createDocumentFragment()
    _.each @tree.children, (child) =>
      childView = new backbonetree.TreeNode
        node: child
        nameField: @nameField
        showLeaves: @showLeaves
        selected: @selected
        parent: null
        treeView: @
        readOnly: @readOnly
      @childViews.push(childView)
      elem.appendChild(childView.render().el)
    @$el.html(elem)
    @resetNodes(@)
    return this

  collectCheckedNodes: =>
    checkedNodes = _.map @childViews, (view) =>
      view.collectCheckedNodes([])
    _.flatten(checkedNodes)

  removeChildren: =>
    _.each @childViews, (view) =>
      view.remove()

  remove: =>
    @removeChildren()
    @stopListening()
    @undelegateEvents()
    super()

  resetNodes: (node) =>
    queue = []
    next = node
    while next
      if not next.reset() && next.childViews.length
        _.each next.childViews, (child) =>
          queue.push(child)
      next = queue.shift()

  reset: =>
    return false