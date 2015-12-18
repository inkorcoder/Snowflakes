var Tree;

(Tree = function(point) {
  var tree;
  tree = new THREE.Mesh(treeGeometry, treeMaterial);
  scene.add(tree);
  return tree;
})();
