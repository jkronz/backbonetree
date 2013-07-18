class backbonetree.TreeNode extends Backbone.View
  tagName: 'li'
  className: 'node collapsed'

  events:
    'click > a.expand': 'expand'
    'change > label > .selected-box': 'toggleSelected'

  initialize: (options) =>
    @node = options.node
    @treeView = options.treeView
    @parent = options.parent
    @nameField = options.nameField || 'name'
    @showLeaves = options.showLeaves
    @selected = options.selected
    if typeof @selected == "function"
      @_selected = @selected
    else
      @_selected = (node) =>
        return node[@selected]
    @childViews = []

  render: =>
    @$el.html(@template())
    fragment = document.createDocumentFragment()
    _.each @node.children, (child) =>
      childView = new backbonetree.TreeNode
        node: child
        parent: @
        selected: @_selected
        nameField: @nameField
        showLeaves: @showLeaves
        treeView: @treeView
      @childViews.push(childView)
      fragment.appendChild(childView.render().el)
    @$('.children').html(fragment)
    return this

  reset: =>
    selected = @_selected(@node)
    if selected then @forceUpdate(selected)
    selected

  toggleSelected: (e) ->
    target = @$(".selected-box:first")
    checked = target.prop("checked")
    @processUpdates(checked)
    @treeView.trigger 'backbonetree:selection_updated', @node

  forceUpdate: (checked) ->
    @$(".selected-box:first").prop('checked', checked)
    @processUpdates(checked)

  processUpdates: (checked) ->
    target = @$(".selected-box:first")
    container = target.parent().parent()
    siblings = container.siblings()

    #update all of the children.
    container.find('input[type="checkbox"]').prop
      indeterminate: false
      checked: checked

    checkSiblings = (el) ->
      parent = el.parent().parent()
      all = true
      el.siblings().each (idx, sib) ->
        ret = $(sib).find('> label > input[type="checkbox"]').prop("checked")
        all = (ret == checked)
      if all && checked
        parent.find('> label > input[type="checkbox"]').prop
          indeterminate: false
          checked: checked
        checkSiblings(parent)
      else if all && not checked
        parent.find('> label > input[type="checkbox"]').prop("checked", checked);
        parent.find('> label > input[type="checkbox"]').prop("indeterminate", (parent.find('input[type="checkbox"]:checked').length > 0));
        checkSiblings(parent)
      else
        el.parents("li").find('> label > input[type="checkbox"]').prop
          indeterminate: true
          checked: false
    checkSiblings(container)

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
        <label class="checkbox"><input type="checkbox" class="selected-box"> #{@node[@nameField]}</label>
        <ul class="children"></ul>
      """
    else if @showLeaves
      """
      <label class="checkbox"><input type="checkbox" class="selected-box"> #{@node[@nameField]}</label>
      """

  collectCheckedNodes: (accum) =>
    if @$(".selected-box:first").prop('checked')
      accum.push(@node)
    else
      _.each @childViews, (view) =>
        view.collectCheckedNodes(accum)
    return accum