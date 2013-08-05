(function() {
  var _ref, _ref1,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.statictree = {};

  statictree.StaticTree = (function(_super) {
    __extends(StaticTree, _super);

    function StaticTree() {
      this.remove = __bind(this.remove, this);
      this.removeChildren = __bind(this.removeChildren, this);
      this.render = __bind(this.render, this);
      this.initializeTree = __bind(this.initializeTree, this);
      this.initialize = __bind(this.initialize, this);
      _ref = StaticTree.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    StaticTree.prototype.tagName = 'ul';

    StaticTree.prototype.className = 'backbonetree static';

    StaticTree.prototype.initialize = function(options) {
      var _this = this;
      this.tree = options.tree;
      this.nameField = options.nameField || 'name';
      this.showLeaves = options.showLeaves || false;
      this.selected = options.selected || function() {
        return false;
      };
      if (typeof this.selected === "function") {
        this._selected = this.selected;
      } else {
        this._selected = function(node) {
          return node[_this.selected];
        };
      }
      this.childViews = [];
      return this.initializeTree(this.tree);
    };

    StaticTree.prototype.initializeTree = function(node) {
      var anySelected, selectedList, selectedNode,
        _this = this;
      selectedNode = this._selected(node);
      if (selectedNode) {
        node.show = true;
        return true;
      } else if ((node.children != null) && node.children.length) {
        selectedList = _.map(node.children, function(childNode) {
          return _this.initializeTree(childNode);
        });
        anySelected = _.any(selectedList);
        node.show = anySelected;
        return anySelected;
      } else {
        node.show = false;
        return false;
      }
    };

    StaticTree.prototype.render = function() {
      this.removeChildren();
      this.topNode = new statictree.StaticTreeNode({
        node: this.tree,
        nameField: this.nameField
      });
      this.$el.html(this.topNode.render().el);
      return this;
    };

    StaticTree.prototype.removeChildren = function() {
      var _ref1;
      return (_ref1 = this.topNode) != null ? _ref1.remove() : void 0;
    };

    StaticTree.prototype.remove = function() {
      this.removeChildren();
      this.stopListening();
      this.undelegateEvents();
      return StaticTree.__super__.remove.call(this);
    };

    return StaticTree;

  })(Backbone.View);

  statictree.StaticTreeNode = (function(_super) {
    __extends(StaticTreeNode, _super);

    function StaticTreeNode() {
      this.remove = __bind(this.remove, this);
      this.removeChildren = __bind(this.removeChildren, this);
      this.template = __bind(this.template, this);
      this.expand = __bind(this.expand, this);
      this.children = __bind(this.children, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      _ref1 = StaticTreeNode.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    StaticTreeNode.prototype.tagName = 'li';

    StaticTreeNode.prototype.className = 'node collapsed';

    StaticTreeNode.prototype.events = {
      'click > a.expand': 'expand'
    };

    StaticTreeNode.prototype.initialize = function(options) {
      this.node = options.node;
      this.nameField = options.nameField || 'name';
      return this.childViews = [];
    };

    StaticTreeNode.prototype.render = function() {
      var node,
        _this = this;
      this.$el.html(this.template());
      node = document.createDocumentFragment();
      _.each(this.children(), function(child) {
        var childView;
        childView = new statictree.StaticTreeNode({
          node: child,
          nameField: _this.nameField
        });
        _this.childViews.push(childView);
        return node.appendChild(childView.render().el);
      });
      this.$('.children').html(node);
      return this;
    };

    StaticTreeNode.prototype.children = function() {
      var _this = this;
      if (this._children) {
        return this._children;
      }
      return this.childrenMemo = _.filter(this.node.children, function(child) {
        return child.show;
      });
    };

    StaticTreeNode.prototype.expand = function(event) {
      if (this.$el.is(".collapsed")) {
        this.$el.removeClass('collapsed');
      } else {
        this.$el.addClass('collapsed');
      }
      if (event != null) {
        event.stopPropagation();
      }
      return event != null ? event.preventDefault() : void 0;
    };

    StaticTreeNode.prototype.template = function() {
      if (this.children().length > 0) {
        return "<a href=\"#\" class=\"expand\">\n  <i class=\"icon-expand-alt\"></i>\n  <i class=\"icon-collapse-alt\"></i>\n</a>\n<label class=\"checkbox\">" + this.node[this.nameField] + "</label>\n<ul class=\"children\"></ul>";
      } else {
        return "<label class=\"checkbox\">" + this.node[this.nameField] + "</label>";
      }
    };

    StaticTreeNode.prototype.removeChildren = function() {
      var _this = this;
      return _.each(this.childViews, function(view) {
        return view.remove();
      });
    };

    StaticTreeNode.prototype.remove = function() {
      this.removeChildren();
      this.stopListening();
      this.undelegateEvents();
      return StaticTreeNode.__super__.remove.call(this);
    };

    return StaticTreeNode;

  })(Backbone.View);

}).call(this);
