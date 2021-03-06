class backbonetree.TreeNode extends Backbone.View
  tagName: 'li'
  className: 'node collapsed'

  events:
    'click > a.expand': 'expand'
    'change > label > .selected-box': 'toggleSelected'

  initialize: (options) =>
    @node = options.node
    @readOnly = options.readOnly
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
        readOnly: @readOnly
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

    #update all of the children.
    container.find('input[type="checkbox"]').prop
      indeterminate: false
      checked: checked
    @parent?.updateParentNodes()

  updateParentNodes: =>
    any = _.any @childViews, (vw) =>
      vw.$('.selected-box:first').prop('checked') || vw.$('.selected-box:first').prop('indeterminate')
    #if not any, then all must be false, no reason to iterate and check.
    all = any && _.all @childViews, (vw) =>
      vw.$('.selected-box:first').prop('checked')
    @$('.selected-box:first').prop
      checked: all
      indeterminate: any && !all
      disabled: @readOnly
    @parent?.updateParentNodes()

  expand: (event) =>
    if @$el.is(".collapsed")
      @$el.removeClass('collapsed')
    else
      @$el.addClass('collapsed')
    event?.stopPropagation()
    event?.preventDefault()

  template: =>
    if @node.children? && @node.children.length
      """
        <a href="#" class="expand">
          <i class="icon-expand-alt"></i>
          <i class="icon-collapse-alt"></i>
        </a>
        <label class="checkbox"><input type="checkbox" class="selected-box" #{if @readOnly then "disabled"}> #{@node[@nameField]}</label>
        <ul class="children"></ul>
      """
    else if @showLeaves
      """
      <label class="checkbox"><input type="checkbox" class="selected-box" #{if @readOnly then "disabled"}> #{@node[@nameField]}</label>
      """

  collectCheckedNodes: (accum) =>
    if @$(".selected-box:first").prop('checked')
      accum.push(@node)
    else
      _.each @childViews, (view) =>
        view.collectCheckedNodes(accum)
    return accum

  removeChildren: =>
    _.each @childViews, (view) =>
      view.remove()

  remove: =>
    @removeChildren()
    @stopListening()
    @undelegateEvents()
    super()