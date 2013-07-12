backbonetree
=============

Selectable Tree View via Backbone.js. See the demo: http://jkronz.github.io/backbonetree/

##Usage
You'll want to grab `dist/app/backbonetree.js` and `dist/style/backbonetree.css`

```
  $(function() {
    var treeView = new backbonetree.TreeView({
      tree: sampledata,    //json tree data, children should be specified as a "children" attribute. see sampledata.js
      nameField: 'symbol', //What attribute of the node should be displayed as the label for that node?
      showLeaves: true     //Display the leaf nodes?
    });
    $(".the-tree").html(treeView.render().el);
  });
```

When you're done with the tree, calling `TreeView#remove()` will close the child views and wrap up all event listeners.

##Events
When selections are changed, 'backbonetree:selection_updated' is fired on the global Backbone object.
You can call `TreeView#collectCheckedNodes()` to get all the objects that are currently selected. Note that this will only return the topmost checked nodes; selected children are implied.

##Style
Tree is styled with bootstrap (http://twitter.github.io/bootstrap/) and font-awesome (http://fortawesome.github.io/Font-Awesome/) for the expand/collapse icons. 
