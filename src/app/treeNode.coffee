class backstraptree.TreeNode extends Backbone.View
  events:
    'click * > a.expand': 'expand'
    'change * > .selected-box': 'toggleSelected'

  initialize: (options) =>
    @node = options.node
    @nameField = options.nameField || 'name'
    @showLeaves = options.showLeaves
    @childViews = []

  render: =>
    @$el.html(@template())
    fragment = document.createDocumentFragment()
    _.each @node.children, (child) =>
      childView = new backstraptree.TreeNode({node: child, nameField: @nameField, showLeaves: @showLeaves})
      @childViews.push(childView)
      fragment.appendChild(childView.render().el)
    @$('.children').html(fragment)
    return this

  toggleSelected: (event) =>
    targetChecked = @$(".selected-box:first").prop('checked')
    @$(".selected-box").prop('checked', targetChecked)
    event.stopPropagation()
    Backbone.trigger 'backstraptree:selection_updated'

  expand: (event) =>
    target = @$("li.node:first")
    if target.is(".collapsed")
      target.removeClass('collapsed')
    else
      target.addClass('collapsed')
    event.stopPropagation()

  template: =>
    if @node.children? && @node.children.length
      """
      <li class="node collapsed">
        <a href="#" class="expand">
          <i class="icon-expand-alt"></i>
          <i class="icon-collapse-alt"></i>
        </a>
        <label><input type="checkbox" class="selected-box">#{@node[@nameField]}</label>
        <ul class="children"></ul>
      </li>
      """
    else if @showLeaves
      """
      <li class="node">#{@node[@nameField]}</li>
      """

  collectCheckedNodes: (accum) =>
    if @$(".selected-box:first").prop('checked')
      accum.push(@node)
    else
      _.each @childViews, (view) =>
        view.collectCheckedNodes(accum)
    return accum