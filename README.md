backbonetree
=============

Selectable Tree View via Backbone.js

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

##Style
Tree is styled with bootstrap (http://twitter.github.io/bootstrap/) and font-awesome (http://fortawesome.github.io/Font-Awesome/) for the expand/collapse icons. 
