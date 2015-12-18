var getCoordinates, raycaster;

window.onresize = function() {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  return renderer.setSize(window.innerWidth, window.innerHeight);
};

raycaster = new THREE.Raycaster();

getCoordinates = function(ev) {
  var mouse;
  mouse = new THREE.Vector2();
  if (ev.originalEvent.touches !== void 0) {
    mouse.y = -(ev.originalEvent.touches[0].pageY / renderer.domElement.height) * 2 + 1;
    mouse.x = (ev.originalEvent.touches[0].pageX / renderer.domElement.width) * 2 - 1;
  } else {
    mouse.y = -(ev.clientY / renderer.domElement.height) * 2 + 1;
    mouse.x = (ev.clientX / renderer.domElement.width) * 2 - 1;
  }
  return mouse;
};

$('#reload').click(function(e) {
  e.preventDefault();
  return location.reload();
});
