window.backbonetree = {}
class backbonetree.TreeView extends Backbone.View
  tagName: 'ul'
  className: 'backbonetree'

  initialize: (options) =>
    @tree = options.tree
    @nameField = options.nameField || 'name'
    @showLeaves = options.showLeaves || false
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
      @childViews.push(childView)
      elem.appendChild(childView.render().el)
    @$el.html(elem)
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
