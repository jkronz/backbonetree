class backbonetree.TreeNode extends Backbone.View
  tagName: 'li'
  className: 'node collapsed'

  events:
    'click > a.expand': 'expand'
    'change > label > .selected-box': 'toggleSelected'

  initialize: (options) =>
    @node = options.node
    @nameField = options.nameField || 'name'
    @showLeaves = options.showLeaves
    @selected = options.selected
    if typeof @selected == "function"
      @_selected = @selected
    else
      @_selected = (node) =>
        return node[@selected]
    @disabled = options.disabled || false
    @checked = @disabled || @_selected(@node)
    @childViews = []

  render: =>
    @$el.html(@template())
    fragment = document.createDocumentFragment()
    _.each @node.children, (child) =>
      childView = new backbonetree.TreeNode
        node: child
        selected: @_selected
        nameField: @nameField
        showLeaves: @showLeaves
        disabled: @disabled || @checked #if this item is disabled or checked, all of its children are disabled.
      @childViews.push(childView)
      fragment.appendChild(childView.render().el)
    @$('.children').html(fragment)
    return this

  toggleSelected: (event) =>
    target = @$(".selected-box:first")
    targetChecked = target.prop('checked')
    children = @$(".selected-box")
    children.prop('checked', targetChecked)
    children.prop('disabled', targetChecked)
    target.prop('disabled', false)
    event?.stopPropagation()
    Backbone.trigger 'backbonetree:selection_updated'

  expand: (event) =>
    if @$el.is(".collapsed")
      @$el.removeClass('collapsed')
    else
      @$el.addClass('collapsed')
    event.stopPropagation()
    event.preventDefault()

  template: =>
    if @node.children? && @node.children.length
      """
        <a href="#" class="expand">
          <i class="icon-expand-alt"></i>
          <i class="icon-collapse-alt"></i>
        </a>
        <label class="checkbox"><input type="checkbox" class="selected-box"
          #{if @checked then "checked"}
          #{if @disabled then "disabled"}
          >#{@node[@nameField]}</label>
        <ul class="children"></ul>
      """
    else if @showLeaves
      """
      <label class="checkbox"><input type="checkbox" class="selected-box"
        #{if @checked then "checked"}
        #{if @disabled then "disabled"}
        >#{@node[@nameField]}</label>
      """

  collectCheckedNodes: (accum) =>
    if @$(".selected-box:first").prop('checked')
      accum.push(@node)
    else
      _.each @childViews, (view) =>
        view.collectCheckedNodes(accum)
    return accum