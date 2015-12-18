var BODY, CAMERA, H, LIGHT, RENDER, SCENE, STARS, STARS2, W, animate, container, earth, earthGeo, earthMat, earthTexture, getRandomInt, i, j, jupiter, jupiterGeo, jupiterMat, jupiterTexture, k, mars, marsGeo, marsMat, marsTexture, mercury, mercuryGeo, mercuryMat, mercuryTexture, neptun, neptunGeo, neptunMat, neptunTexture, opacities, orbit, pluton, plutonGeo, plutonMat, plutonTexture, saturn, saturnGeo, saturnMat, saturnTexture, stars2Geo, stars2Mat, starsGeo, starsMat, sun, sunGeo, sunMat, sunTexture, t, uran, uranGeo, uranMat, uranTexture, v, venus, venusGeo, venusMat, venusTexture, webglAvailable, x, y;

getRandomInt = function(min, max) {
  var rand;
  rand = Math.floor(Math.random() * (max - min + 1)) + min;
  return rand;
};

orbit = function(radius, scene) {
  var i, j, obj, og, om, v;
  this.radius = radius;
  og = new THREE.Geometry();
  om = new THREE.ParticleBasicMaterial({
    color: 0x222222,
    size: 1,
    sizeAttenuation: false
  });
  for (i = j = 0; j < 50000; i = ++j) {
    v = new THREE.Vector3();
    v.x = Math.sin(Math.PI / 180 * i) * this.radius;
    v.z = Math.cos(Math.PI / 180 * i) * this.radius;
    og.vertices.push(v);
  }
  obj = new THREE.ParticleSystem(og, om);
  return scene.add(obj);
};

BODY = document.body;

container = document.createElement('div');

BODY.appendChild(container);

W = parseInt(window.innerWidth);

H = parseInt(window.innerHeight);

CAMERA = new THREE.PerspectiveCamera(45, W / H, 1, 1000000);

CAMERA.position.z = 5000;

SCENE = new THREE.Scene();

LIGHT = new THREE.PointLight(0xffffff, 1.4, 35000);

LIGHT.position.set(0, 0, 0);

LIGHT.castShadow = true;

LIGHT.shadowMapWidth = 2048;

LIGHT.shadowMapHeight = 2048;

SCENE.add(LIGHT);

opacities = [0x555555, 0x666666, 0x777777, 0x888888, 0x999999, 0xaaaaaa, 0xbbbbbb, 0xcccccc];

starsGeo = new THREE.Geometry();

starsMat = new THREE.PointCloudMaterial({
  color: 0x444444,
  size: 1,
  opacity: 0.5,
  sizeAttenuation: false
});

for (i = j = 0; j < 45000; i = ++j) {
  v = new THREE.Vector3();
  v.x = Math.random() * 2 - 1;
  v.y = Math.random() * 2 - 1;
  v.z = Math.random() * 2 - 1;
  v.multiplyScalar(6000);
  starsGeo.vertices.push(v);
}

STARS = new THREE.PointCloud(starsGeo, starsMat);

STARS.scale.set(100, 100, 100);

SCENE.add(STARS);

stars2Geo = new THREE.Geometry();

stars2Mat = new THREE.PointCloudMaterial({
  color: 0x999999,
  size: 1,
  opacity: 0.5,
  sizeAttenuation: false
});

for (i = k = 0; k < 10000; i = ++k) {
  v = new THREE.Vector3();
  v.x = Math.random() * 2 - 1;
  v.y = Math.random() * 2 - 1;
  v.z = Math.random() * 2 - 1;
  v.multiplyScalar(6000);
  stars2Geo.vertices.push(v);
}

STARS2 = new THREE.PointCloud(stars2Geo, stars2Mat);

STARS2.scale.set(100, 100, 100);

SCENE.add(STARS2);

sunGeo = new THREE.SphereGeometry(1300, 80, 80);

sunTexture = new THREE.ImageUtils.loadTexture('img/sun.jpg');

sunTexture.anisotropy = 12;

sunMat = new THREE.MeshBasicMaterial({
  map: sunTexture,
  color: 0xffffff
});

sun = new THREE.Mesh(sunGeo, sunMat);

SCENE.add(sun);

mercuryGeo = new THREE.SphereGeometry(50, 20, 20);

mercuryTexture = new THREE.ImageUtils.loadTexture('img/mercury.jpg');

mercuryTexture.anisotropy = 12;

mercuryMat = new THREE.MeshPhongMaterial({
  map: mercuryTexture
});

mercury = new THREE.Mesh(mercuryGeo, mercuryMat);

SCENE.add(mercury);

venusGeo = new THREE.SphereGeometry(70, 20, 20);

venusTexture = new THREE.ImageUtils.loadTexture('img/venus.jpg');

venusTexture.anisotropy = 12;

venusMat = new THREE.MeshPhongMaterial({
  map: venusTexture
});

venus = new THREE.Mesh(venusGeo, venusMat);

SCENE.add(venus);

earthGeo = new THREE.SphereGeometry(100, 20, 20);

earthTexture = new THREE.ImageUtils.loadTexture('img/earth.jpg');

earthTexture.anisotropy = 12;

earthMat = new THREE.MeshPhongMaterial({
  map: earthTexture
});

earth = new THREE.Mesh(earthGeo, earthMat);

SCENE.add(earth);

marsGeo = new THREE.SphereGeometry(70, 20, 20);

marsTexture = new THREE.ImageUtils.loadTexture('img/mars.gif');

marsTexture.anisotropy = 12;

marsMat = new THREE.MeshPhongMaterial({
  map: marsTexture
});

mars = new THREE.Mesh(marsGeo, marsMat);

SCENE.add(mars);

jupiterGeo = new THREE.SphereGeometry(270, 50, 50);

jupiterTexture = new THREE.ImageUtils.loadTexture('img/jupiter.jpg');

jupiterTexture.anisotropy = 12;

jupiterMat = new THREE.MeshPhongMaterial({
  map: jupiterTexture
});

jupiter = new THREE.Mesh(jupiterGeo, jupiterMat);

jupiter.castShadow = true;

SCENE.add(jupiter);

saturnGeo = new THREE.SphereGeometry(170, 50, 50);

saturnTexture = new THREE.ImageUtils.loadTexture('img/saturn.jpg');

saturnTexture.anisotropy = 12;

saturnMat = new THREE.MeshPhongMaterial({
  map: saturnTexture
});

saturn = new THREE.Mesh(saturnGeo, saturnMat);

SCENE.add(saturn);

uranGeo = new THREE.SphereGeometry(100, 50, 50);

uranTexture = new THREE.ImageUtils.loadTexture('img/neptun.jpg');

uranTexture.anisotropy = 12;

uranMat = new THREE.MeshPhongMaterial({
  map: uranTexture
});

uran = new THREE.Mesh(uranGeo, uranMat);

SCENE.add(uran);

neptunGeo = new THREE.SphereGeometry(40, 20, 20);

neptunTexture = new THREE.ImageUtils.loadTexture('img/neptun.jpg');

neptunTexture.anisotropy = 12;

neptunMat = new THREE.MeshPhongMaterial({
  map: neptunTexture,
  color: 0x888888
});

neptun = new THREE.Mesh(neptunGeo, neptunMat);

SCENE.add(neptun);

plutonGeo = new THREE.SphereGeometry(30, 20, 20);

plutonTexture = new THREE.ImageUtils.loadTexture('img/pluton.jpg');

plutonTexture.anisotropy = 12;

plutonMat = new THREE.MeshPhongMaterial({
  map: plutonTexture
});

pluton = new THREE.Mesh(plutonGeo, plutonMat);

SCENE.add(pluton);

webglAvailable = function() {
  var canvas, e, error;
  try {
    canvas = document.createElement('canvas');
    return !!(window.WebGLRenderingContext && (canvas.getContext('webgl') || canvas.getContext('experimental-webgl')));
  } catch (error) {
    e = error;
    return false;
  }
};

if (webglAvailable()) {
  RENDER = new THREE.WebGLRenderer();
} else {
  alert('Your browser doesn`t support WEBGL');
}

RENDER.setSize(W, H);

container.appendChild(RENDER.domElement);

t = 0;

x = 0;

y = 0;

document.addEventListener('mousemove', function(e) {
  x = parseInt(e.offsetX);
  return y = parseInt(e.offsetY);
});

CAMERA.position.y = 13000;

orbit(4000, SCENE);

orbit(5500, SCENE);

orbit(7000, SCENE);

orbit(8000, SCENE);

orbit(12000, SCENE);

orbit(15000, SCENE);

orbit(17000, SCENE);

orbit(18000, SCENE);

orbit(20000, SCENE);

animate = function() {
  requestAnimationFrame(animate);
  sun.rotation.y += 0.001;
  mercury.position.x = Math.sin(t * 0.2 / 4) * 4000;
  mercury.position.z = Math.cos(t * 0.2 / 4) * 4000;
  venus.position.x = Math.sin(-t * 0.17 / 4) * 5500;
  venus.position.z = Math.cos(-t * 0.17 / 4) * 5500;
  earth.position.x = Math.sin(t * 0.15 / 4) * 7000;
  earth.position.z = Math.cos(t * 0.15 / 4) * 7000;
  mars.position.x = Math.sin(t * 0.12 / 4) * 8000;
  mars.position.z = Math.cos(t * 0.12 / 4) * 8000;
  jupiter.position.x = Math.sin(-t * 0.1 / 4) * 12000;
  jupiter.position.z = Math.cos(-t * 0.1 / 4) * 12000;
  saturn.position.x = Math.sin(t * 0.09 / 4) * 15000;
  saturn.position.z = Math.cos(t * 0.09 / 4) * 15000;
  uran.position.x = Math.sin(-t * 0.08 / 4) * 17000;
  uran.position.z = Math.cos(-t * 0.08 / 4) * 17000;
  neptun.position.x = Math.sin(t * 0.07 / 4) * 18000;
  neptun.position.z = Math.cos(t * 0.07 / 4) * 18000;
  pluton.position.x = Math.sin(t * 0.06 / 4) * 20000;
  pluton.position.z = Math.cos(t * 0.06 / 4) * 20000;
  CAMERA.position.y = y * 100;
  CAMERA.lookAt(SCENE.position);
  t += Math.PI / 180 * 2;
  return RENDER.render(SCENE, CAMERA);
};

animate();
