var CATCHED, OBJECTS, SNOW, UNCATCHED, ZOOM, activeObject, addSnow, anim, camera, clock, cube, delta, endOfGame, ground, i, j, jsonLoader, k, keys, lastObjsLength, lastSnowRand, light, obj, obj2, og, og2, om, om2, plane, pointLight, render, renderer, scene, sky, skyTexture, snowGeo, snowMat, snowSpeed, snowTexture, snowball, textureLoader, treeGeometry, treeMaterial, v, waterTexture, webglAvailable;

scene = new THREE.Scene();

camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 0.1, 1000);

webglAvailable = function() {
  var _error, canvas, e, error;
  canvas = void 0;
  e = void 0;
  try {
    canvas = document.createElement('canvas');
    return !!(window.WebGLRenderingContext && (canvas.getContext('webgl') || canvas.getContext('experimental-webgl')));
  } catch (error) {
    _error = error;
    e = _error;
    return false;
  }
};

if (webglAvailable()) {
  renderer = new THREE.WebGLRenderer({
    alpha: true,
    antialias: true
  });
  renderer.setClearColor(0x000000, 0);
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.getElementById('webglRender').appendChild(renderer.domElement);
  renderer.setPixelRatio(window.devicePixelRatio);
} else {
  alert('Ваш браузер не поддерживает технологию WEBGL');
}

OBJECTS = [];

activeObject = null;

window.currentZoom = 0;

window.currentZoomOld = 0;

lastObjsLength = 0;

ZOOM = {
  max: 60000,
  min: -40000
};

snowSpeed = 0.01;

cube = new THREE.Mesh(new THREE.BoxGeometry(1, 1, 1), new THREE.MeshNormalMaterial({
  transparent: true,
  opacity: 0
}));

scene.add(cube);

cube.position.x = 0;

cube.position.y = 8;

cube.position.z = 20;

CATCHED = 0;

UNCATCHED = 0;

jsonLoader = new THREE.JSONLoader();

textureLoader = new THREE.TextureLoader();

treeGeometry = {};

treeMaterial = {};

ground = {};

jsonLoader.load('models/CartoonTree.js', function(geo) {
  var arr, i, texture, x, y, z;
  treeGeometry = geo;
  texture = textureLoader.load("textures/elka.jpg", function() {
    texture.wrapS = THREE.RepeatWrapping;
    texture.wrapT = THREE.RepeatWrapping;
    return texture.repeat.set(4, 4);
  });
  treeMaterial = new THREE.MeshPhongMaterial({
    map: texture,
    emissive: 0x000000
  });
  x = 0;
  y = 0;
  z = 0;
  i = 0;
  return arr = [];
});

skyTexture = textureLoader.load("textures/sky.jpg", function() {});

snowTexture = textureLoader.load("textures/snow.png", function() {
  return skyTexture.anisotropy = 16;
});

sky = new THREE.Mesh(new THREE.SphereGeometry(50, 50, 50), new THREE.MeshPhongMaterial({
  color: 0xffffff,
  emissive: 0x000000,
  map: skyTexture,
  side: THREE.BackSide
}));

scene.add(sky);

og = new THREE.Geometry();

og2 = new THREE.Geometry();

om = new THREE.PointsMaterial({
  color: 0x99bbdd,
  size: 1,
  sizeAttenuation: false
});

om2 = new THREE.PointsMaterial({
  color: 0x225599,
  size: 1,
  sizeAttenuation: false
});

for (i = j = 0; j < 10000; i = ++j) {
  v = new THREE.Vector3();
  v.x = rand(-30, 30);
  v.y = rand(0, 20);
  v.z = rand(-20, 20);
  og.vertices.push(v);
}

obj = new THREE.Points(og, om);

scene.add(obj);

for (i = k = 0; k < 40000; i = ++k) {
  v = new THREE.Vector3();
  v.x = rand(-30, 30);
  v.y = rand(0, 20);
  v.z = rand(-20, 20);
  og2.vertices.push(v);
}

obj2 = new THREE.Points(og2, om2);

scene.add(obj2);

jsonLoader.load('models/ground.js', function(geo) {
  var mat, texture;
  texture = textureLoader.load("textures/ttt.jpg", function() {
    texture.wrapS = THREE.RepeatWrapping;
    return texture.wrapT = THREE.RepeatWrapping;
  });
  mat = new THREE.MeshPhongMaterial({
    map: texture,
    emissive: 0x000000
  });
  ground = new THREE.Mesh(geo, mat);
  ground.scale.set(50, 50, 50);
  ground.position.y = -0.1;
  ground.rotation.y = rad(-90);
  return scene.add(ground);
});

snowball = {};

snowGeo = null;

snowMat = new THREE.MeshPhongMaterial({
  side: THREE.DoubleSide,
  color: 0xbbccdd,
  emissive: 0x999999
});

jsonLoader.load('models/snow.js', function(geo) {
  var mat;
  snowGeo = geo;
  mat = new THREE.MeshPhongMaterial({
    side: THREE.DoubleSide,
    color: 0xddeeff,
    emissive: 0x999999
  });
  snowball = new THREE.Mesh(geo, mat);
  scene.add(snowball);
  snowball.scale.set(0.5, 0.5, 0.5);
  return snowball.isAnimated = false;
});

jsonLoader.load('models/house.js', function(geo) {
  var house, mat, texture;
  texture = textureLoader.load("textures/house.jpg", function() {});
  mat = new THREE.MeshPhongMaterial({
    map: texture,
    color: 0xddeeff,
    emissive: 0x000000
  });
  house = new THREE.Mesh(geo, mat);
  house.position.y = 6;
  house.position.z = -32;
  house.rotation.y = -1.6;
  scene.add(house);
  return house.scale.set(3, 3, 3);
});

SNOW = [];

lastSnowRand = 0;

addSnow = function() {
  var ar, r, snow;
  ar = [-6.8, 0, 6.8];
  r = parseInt(rand(0, 2.9));
  if (r !== lastSnowRand) {
    snow = new THREE.Mesh(snowGeo, snowMat);
    scene.add(snow);
    snow.position.z = snowball.position.z - 10;
    snow.position.y = snowball.position.y;
    snow.position.x = ar[r];
    snow.scale.set(0.4, 0.4, 0.4);
    SNOW.push(snow);
    return lastSnowRand = r;
  }
};

light = new THREE.AmbientLight(0x000000);

scene.add(light);

pointLight = new THREE.PointLight(0xbbddff, 1, 60);

pointLight.position.set(0, 50, -10);

scene.add(pointLight);

waterTexture = textureLoader.load("textures/water.jpg", function() {
  waterTexture.wrapS = THREE.RepeatWrapping;
  waterTexture.wrapT = THREE.RepeatWrapping;
  waterTexture.repeat.set(1, 2);
  return waterTexture.anisotropy = 16;
});

plane = new THREE.Mesh(new THREE.PlaneGeometry(100, 100, 10), new THREE.MeshPhongMaterial({
  color: 0x444499,
  emissive: 0x000000,
  map: waterTexture
}));

plane.position.y = 1.5;

plane.rotation.x = rad(-90);

scene.add(plane);

camera.position.y = 30;

camera.position.z = 35;

clock = new THREE.Clock();

clock.start();

keys = new THREEx.KeyboardState();

endOfGame = function() {
  $('#total').html("catched: " + CATCHED + " missed: " + UNCATCHED + " <br> (" + (((CATCHED / UNCATCHED) * 100).toFixed(1)) + "%) <small>looser :)</small>");
  return $('#popup').fadeIn(2000);
};

delta = 0;

anim = 0;

render = function() {
  var P, _r, _s, l, leftStr, len, len1, len2, m, n, o, p, ref, ref1, s, sc, ss;
  requestAnimationFrame(render);
  if (camera.position.z > -10) {
    camera.position.z -= 0.01;
  }
  if (camera.position.y > cube.position.y + 1) {
    camera.position.y -= 0.005;
  }
  ref = obj.geometry.vertices;
  for (i = l = 0, len = ref.length; l < len; i = ++l) {
    v = ref[i];
    v.y -= snowSpeed;
    if (rand(-1, 1) > 0) {
      v.x += (Math.sin(delta / 50)) / 50;
    } else {
      v.x += (Math.cos(delta / 50)) / 50;
    }
    if (v.y < 0) {
      v.y = 20;
    }
  }
  ref1 = obj2.geometry.vertices;
  for (i = m = 0, len1 = ref1.length; m < len1; i = ++m) {
    v = ref1[i];
    v.y -= snowSpeed;
    if (rand(-1, 1) > 0) {
      v.x += (Math.sin(delta / 50)) / 50;
    } else {
      v.x += (Math.cos(delta / 50)) / 50;
    }
    if (v.y < 0) {
      v.y = 20;
    }
  }
  obj.geometry.verticesNeedUpdate = true;
  obj.geometry.elementsNeedUpdate = true;
  obj2.geometry.verticesNeedUpdate = true;
  obj2.geometry.elementsNeedUpdate = true;
  camera.lookAt(cube.position);
  if (snowball) {
    if (camera.position.z > -10) {
      snowball.position.z = cube.position.z + 2;
      snowball.position.y = cube.position.y + (Math.sin(delta / 10));
      snowball.rotation.x += (snowball.isAnimated === 'left') || (snowball.isAnimated === 'right') ? 0.2 : 0.1;
      snowball.rotation.y += (snowball.isAnimated === 'left') || (snowball.isAnimated === 'right') ? 0.3 : 0.2;
      snowball.rotation.z += 0.01;
    } else {
      snowball.rotation.x = -1.6;
      snowball.rotation.y = 0;
      snowball.rotation.z = 0;
      endOfGame();
    }
  }
  for (n = 0, len2 = SNOW.length; n < len2; n++) {
    s = SNOW[n];
    P = snowball.position;
    p = s.position;
    ss = snowball.scale.x;
    if (s.position.z > snowball.position.z + ss) {
      s.visible = false;
      if (!s.visible && !s.checked) {
        s.checked = true;
        UNCATCHED++;
      }
    }
    if (s.visible) {
      s.position.z += delta / 6000;
      s.rotation.z += 0.01;
      s.rotation.x += 0.1;
      if ((p.x > P.x - ss) && (p.x < P.x + ss) && (p.z > P.z - ss) && (p.z < P.z + ss)) {
        s.visible = false;
        sc = snowball.scale.x + 0.001;
        snowball.scale.set(sc, sc, sc);
        CATCHED++;
      }
    }
  }
  if ((keys.pressed('left')) && (snowball.position.x > -5)) {
    if (snowball.isAnimated === false) {
      snowball.isAnimated = 'left';
      snowball.frame = 0;
    }
  }
  if ((keys.pressed('right')) && (snowball.position.x < 5)) {
    if (snowball.isAnimated === false) {
      snowball.isAnimated = 'right';
      snowball.frame = 0;
    }
  }
  if (snowball.isAnimated === 'left') {
    snowball.position.x -= Math.sin(snowball.frame);
    snowball.frame += 0.3;
    if (snowball.frame > 3.2) {
      snowball.frame = 0;
      snowball.isAnimated = false;
    }
  }
  if (snowball.isAnimated === 'right') {
    snowball.position.x += Math.sin(snowball.frame);
    snowball.frame += 0.3;
    if (snowball.frame > 3.2) {
      snowball.frame = 0;
      snowball.isAnimated = false;
    }
  }
  if (cube.position.z > -24) {
    cube.position.z -= 0.01;
  }
  plane.position.y += (Math.sin(delta / 50)) / 500;
  leftStr = "[";
  for (_s = o = 0; o <= 48; _s = ++o) {
    leftStr += snowball.position.z + 10 >= _s ? '|' : '.';
  }
  leftStr += "]";
  $('#catched').html(CATCHED + '/' + UNCATCHED);
  $('#left').html(snowball.position.z);
  $('#left2').html(leftStr);
  if (delta > 4000) {
    _r = 0.5;
  } else if (delta > 3000) {
    _r = 2;
  } else if (delta > 2000) {
    _r = 8;
  } else if (delta > 1000) {
    _r = 16;
  } else {
    _r = 32;
  }
  if ((parseInt(rand(-_r, _r)) === 0) && snowball.position.z > -20) {
    addSnow();
  }
  delta += 1;
  anim++;
  if (anim > 180) {
    anim = 0;
  }
  camera.updateProjectionMatrix();
  return renderer.render(scene, camera);
};

render();
