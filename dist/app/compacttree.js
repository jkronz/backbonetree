(function() {
  var _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.compactTree = {};

  compactTree.CompactTree = (function(_super) {
    __extends(CompactTree, _super);

    function CompactTree() {
      this.template = __bind(this.template, this);
      this.calculateSelected = __bind(this.calculateSelected, this);
      this.refreshViewport = __bind(this.refreshViewport, this);
      this.showParent = __bind(this.showParent, this);
      _ref = CompactTree.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    CompactTree.prototype.className = 'compact-tree';

    CompactTree.prototype.events = {
      'click .back': 'showParent'
    };

    CompactTree.prototype.initialize = function(options) {
      this.tree = options.tree;
      this.childViews = [];
      this.nameField = options.nameField;
      this.listenTo(this, 'compact-tree:updateViewport', this.refreshViewport);
      if (typeof options.selected === "string") {
        this._selected = function(node) {
          return node[options.selected];
        };
      } else {
        this._selected = options.selected;
      }
      return this.calculateSelected(this.tree, null);
    };

    CompactTree.prototype.render = function() {
      var view;
      view = new compactTree.CompactTreeNode({
        node: this.tree,
        parent: null,
        nameField: this.nameField,
        treeView: this
      });
      this.childViews.push(view);
      view.render();
      this.$el.html(this.template());
      this.refreshViewport(view);
      return this;
    };

    CompactTree.prototype.showParent = function(event) {
      this.refreshViewport(this.currentView.parent);
      if (event != null) {
        event.stopPropagation();
      }
      return event != null ? event.preventDefault() : void 0;
    };

    CompactTree.prototype.refreshViewport = function(currentView) {
      this.currentView = currentView;
      if (this.currentView.parent != null) {
        this.$('.back').show();
      } else {
        this.$('.back').hide();
      }
      return this.$('.tree-items').html(this.currentView.childMarkup());
    };

    CompactTree.prototype.calculateSelected = function(node, parent) {
      var childrenSelected,
        _this = this;
      if ((node.children != null) && node.children.length > 0) {
        if (((parent != null) && parent.allSelected) || this._selected(node)) {
          node.allSelected = true;
          _.each(node.children, function(child) {
            return _this.calculateSelected(child, node);
          });
        } else {
          childrenSelected = _.map(node.children, function(child) {
            return _this.calculateSelected(child, node);
          });
          node.anySelected = _.any(childrenSelected);
          node.allSelected = node.anySelected && _.all(childrenSelected);
        }
      } else {
        node.allSelected = ((parent != null) && parent.allSelected) || this._selected(node);
      }
      return node.allSelected;
    };

    CompactTree.prototype.remove = function() {
      _.each(this.childViews, function(vw) {
        return vw.remove();
      });
      return CompactTree.__super__.remove.call(this);
    };

    CompactTree.prototype.template = function() {
      return "<a class=\"back\" href=\"#\"><i class=\"icon-caret-left\"></i> Back</a>\n<ul class=\"tree-items\"></ul>";
    };

    return CompactTree;

  })(Backbone.View);

}).call(this);

(function() {
  var _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  compactTree.CompactTreeNode = (function(_super) {
    __extends(CompactTreeNode, _super);

    function CompactTreeNode() {
      this.remove = __bind(this.remove, this);
      this.closeChildren = __bind(this.closeChildren, this);
      this.childMarkup = __bind(this.childMarkup, this);
      this.render = __bind(this.render, this);
      this.triggerCurrentViewport = __bind(this.triggerCurrentViewport, this);
      _ref = CompactTreeNode.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    CompactTreeNode.prototype.tagName = 'li';

    CompactTreeNode.prototype.events = {
      'click > a.expand': 'triggerCurrentViewport'
    };

    CompactTreeNode.prototype.initialize = function(options) {
      this.node = options.node;
      this.parent = options.parent;
      this.treeView = options.treeView;
      this.nameField = options.nameField;
      return this.childViews = [];
    };

    CompactTreeNode.prototype.triggerCurrentViewport = function(event) {
      this.treeView.trigger('compact-tree:updateViewport', this);
      if (event != null) {
        event.stopPropagation();
      }
      return event != null ? event.preventDefault() : void 0;
    };

    CompactTreeNode.prototype.render = function() {
      var _this = this;
      this.$el.html(this.template());
      this.delegateEvents();
      _.each(this.node.children, function(childNode) {
        var view;
        view = new compactTree.CompactTreeNode({
          parent: _this,
          treeView: _this.treeView,
          node: childNode,
          nameField: _this.nameField
        });
        return _this.childViews.push(view.render());
      });
      return this;
    };

    CompactTreeNode.prototype.childMarkup = function() {
      var fragment,
        _this = this;
      fragment = document.createDocumentFragment();
      _.each(this.childViews, function(vw) {
        fragment.appendChild(vw.el);
        return vw.delegateEvents();
      });
      return fragment;
    };

    CompactTreeNode.prototype.template = function() {
      var icon;
      icon = this.node.allSelected ? "icon-check" : this.node.anySelected ? "icon-check-minus" : "icon-check-empty";
      if ((this.node.children != null) && this.node.children.length) {
        return "<i class=\"" + icon + "\"></i>\n<a href=\"#\" class=\"expand\"> " + this.node[this.nameField] + " <i class=\"icon-caret-right\"></i></a>";
      } else {
        return "<i class=\"" + icon + "\"></i>\n" + this.node[this.nameField];
      }
    };

    CompactTreeNode.prototype.closeChildren = function() {
      var _this = this;
      return _.each(this.childViews, function(vw) {
        return vw.remove();
      });
    };

    CompactTreeNode.prototype.remove = function() {
      this.closeChildren();
      this.undelegateEvents();
      this.stopListening();
      return CompactTreeNode.__super__.remove.call(this);
    };

    return CompactTreeNode;

  })(Backbone.View);

}).call(this);
