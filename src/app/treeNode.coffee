class backstraptree.TreeNode extends Backbone.View
  events:
    'click .expand': 'expand'
    'change .selected-box': 'toggleSelected'

  initialize: (options) =>
    @node = options.node
    @nameField = options.nameField || 'name'
    @childViews = []

  render: =>
    @$el.html(@template())
    fragment = document.createDocumentFragment()
    _.each @node.children, (child) =>
      childView = new backstraptree.TreeNode({node: child, nameField: @nameField})
      @childViews.push(childView)
      fragment.appendChild(childView.render().el)
    @$('.children').html(fragment)
    return this

  template: =>
    templateText = []
    templateText.push """<li class="node">#{@node[@nameField]}"""
    if @node.children? && @node.children.length
      templateText.push """<ul class="children"></ul>"""
    templateText.push "</li>"
    templateText.join("")

