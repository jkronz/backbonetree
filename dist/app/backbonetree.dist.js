(function() {
  var _ref, _ref1,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.backbonetree = {};

  backbonetree.TreeView = (function(_super) {
    __extends(TreeView, _super);

    function TreeView() {
      this.remove = __bind(this.remove, this);
      this.removeChildren = __bind(this.removeChildren, this);
      this.collectCheckedNodes = __bind(this.collectCheckedNodes, this);
      this.updateCount = __bind(this.updateCount, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      _ref = TreeView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    TreeView.prototype.tagName = 'ul';

    TreeView.prototype.className = 'backbonetree';

    TreeView.prototype.initialize = function(options) {
      this.tree = options.tree;
      this.nameField = options.nameField || 'name';
      this.showLeaves = options.showLeaves || false;
      this.listenTo(Backbone, 'backbonetree:selection_updated', this.updateCount);
      return this.childViews = [];
    };

    TreeView.prototype.render = function() {
      var elem,
        _this = this;
      this.removeChildren();
      elem = document.createDocumentFragment();
      _.each(this.tree.children, function(child) {
        var childView;
        childView = new backbonetree.TreeNode({
          node: child,
          nameField: _this.nameField,
          showLeaves: _this.showLeaves
        });
        _this.childViews.push(childView);
        return elem.appendChild(childView.render().el);
      });
      this.$el.html(elem);
      return this;
    };

    TreeView.prototype.updateCount = function() {
      var selectedNodes;
      selectedNodes = this.collectCheckedNodes();
      return console.log(['selectedNodes.length', selectedNodes.length]);
    };

    TreeView.prototype.collectCheckedNodes = function() {
      var checkedNodes,
        _this = this;
      checkedNodes = _.map(this.childViews, function(view) {
        return view.collectCheckedNodes([]);
      });
      return _.flatten(checkedNodes);
    };

    TreeView.prototype.removeChildren = function() {
      var _this = this;
      return _.each(this.childViews, function(view) {
        return view.remove();
      });
    };

    TreeView.prototype.remove = function() {
      this.removeChildren();
      this.stopListening();
      this.undelegateEvents();
      return TreeView.__super__.remove.call(this);
    };

    return TreeView;

  })(Backbone.View);

  backbonetree.TreeNode = (function(_super) {
    __extends(TreeNode, _super);

    function TreeNode() {
      this.collectCheckedNodes = __bind(this.collectCheckedNodes, this);
      this.template = __bind(this.template, this);
      this.expand = __bind(this.expand, this);
      this.toggleSelected = __bind(this.toggleSelected, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      _ref1 = TreeNode.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    TreeNode.prototype.tagName = 'li';

    TreeNode.prototype.className = 'node collapsed';

    TreeNode.prototype.events = {
      'click > a.expand': 'expand',
      'change > label > .selected-box': 'toggleSelected'
    };

    TreeNode.prototype.initialize = function(options) {
      this.node = options.node;
      this.nameField = options.nameField || 'name';
      this.showLeaves = options.showLeaves;
      return this.childViews = [];
    };

    TreeNode.prototype.render = function() {
      var fragment,
        _this = this;
      this.$el.html(this.template());
      fragment = document.createDocumentFragment();
      _.each(this.node.children, function(child) {
        var childView;
        childView = new backbonetree.TreeNode({
          node: child,
          nameField: _this.nameField,
          showLeaves: _this.showLeaves
        });
        _this.childViews.push(childView);
        return fragment.appendChild(childView.render().el);
      });
      this.$('.children').html(fragment);
      return this;
    };

    TreeNode.prototype.toggleSelected = function(event) {
      var children, target, targetChecked;
      target = this.$(".selected-box:first");
      targetChecked = target.prop('checked');
      children = this.$(".selected-box");
      children.prop('checked', targetChecked);
      children.prop('disabled', targetChecked);
      target.prop('disabled', false);
      event.stopPropagation();
      return Backbone.trigger('backbonetree:selection_updated');
    };

    TreeNode.prototype.expand = function(event) {
      if (this.$el.is(".collapsed")) {
        this.$el.removeClass('collapsed');
      } else {
        this.$el.addClass('collapsed');
      }
      return event.stopPropagation();
    };

    TreeNode.prototype.template = function() {
      if ((this.node.children != null) && this.node.children.length) {
        return "<a href=\"#\" class=\"expand\">\n  <i class=\"icon-expand-alt\"></i>\n  <i class=\"icon-collapse-alt\"></i>\n</a>\n<label class=\"checkbox\"><input type=\"checkbox\" class=\"selected-box\">" + this.node[this.nameField] + "</label>\n<ul class=\"children\"></ul>";
      } else if (this.showLeaves) {
        return "<label class=\"checkbox\"><input type=\"checkbox\" class=\"selected-box\">" + this.node[this.nameField] + "</label>";
      }
    };

    TreeNode.prototype.collectCheckedNodes = function(accum) {
      var _this = this;
      if (this.$(".selected-box:first").prop('checked')) {
        accum.push(this.node);
      } else {
        _.each(this.childViews, function(view) {
          return view.collectCheckedNodes(accum);
        });
      }
      return accum;
    };

    return TreeNode;

  })(Backbone.View);

}).call(this);
