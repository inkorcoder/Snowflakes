var OBJECTS, axisHelper, camera, controls, cube, geometry, material, render, renderer, scene;

OBJECTS = [];

scene = new THREE.Scene();

camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);

renderer = new THREE.WebGLRenderer({
  alpha: true
});

renderer.setClearColor(0x000000, 0);

renderer.setSize(window.innerWidth, window.innerHeight);

document.getElementById('webglRender').appendChild(renderer.domElement);

geometry = new THREE.BoxGeometry(1, 1, 1);

material = new THREE.MeshNormalMaterial();

cube = new THREE.Mesh(geometry, material);

scene.add(cube);

cube.position.z = 1;

camera.position.z = 5;

axisHelper = new THREE.AxisHelper(5);

scene.add(axisHelper);

controls = new THREE.OrbitControls(camera, renderer.domElement);

render = function() {
  requestAnimationFrame(render);
  return renderer.render(scene, camera);
};

render();
