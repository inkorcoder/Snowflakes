var OBJ;

(OBJ = function(model, size, modelTexture, callback) {
  var cube, l;
  cube = {};
  l = new THREE.JSONLoader();
  if (model !== void 0) {
    l.load('models/' + model, function(geo) {
      var material, texture, textureLoader;
      textureLoader = new THREE.TextureLoader();
      texture = textureLoader.load("textures/" + modelTexture, function() {
        texture.wrapS = THREE.RepeatWrapping;
        texture.wrapT = THREE.RepeatWrapping;
        return texture.anisotropy = 16;
      });
      material = new THREE.MeshPhongMaterial({
        map: texture,
        emissive: 0x000000
      });
      cube = new THREE.Mesh(geo, material);
      cube.texturePath = "textures/" + modelTexture;
      cube.hightlighter = new THREE.Mesh(geo, new THREE.MeshPhongMaterial({
        side: THREE.BackSide,
        color: 0x000000
      }));
      scene.add(cube.hightlighter);
      cube.hightlighter.visible = false;
      cube.scale.set(1, 1, 1);
      cube.collisions = {
        x: false,
        X: false,
        y: false,
        Y: false,
        z: false,
        Z: false
      };
      cube.setTexture = function(path) {
        textureLoader = new THREE.TextureLoader();
        texture = textureLoader.load(path, function() {
          texture.wrapS = THREE.RepeatWrapping;
          return texture.wrapT = THREE.RepeatWrapping;
        });
        console.log(path);
        return cube.material.map = texture;
      };
      cube._setRects = function(isFirst) {
        var bbox;
        cube.rotation.y = 0;
        bbox = new THREE.Box3().setFromObject(cube);
        size = {
          x: bbox.max.x - bbox.min.x,
          y: bbox.max.y - bbox.min.y,
          z: bbox.max.z - bbox.min.z
        };
        if (isFirst) {
          cube._firstRect = {
            x: size.x,
            y: size.y,
            z: size.z
          };
        }
        cube._rect = {
          x: size.x,
          y: size.y,
          z: size.z
        };
        return cube.rect = {
          x: size.x,
          y: size.y,
          z: size.z
        };
      };
      cube._setRects(true);
      cube.rot = 0;
      cube._updateRect = function(R) {
        var r, scale;
        scale = {
          x: R.x / cube._firstRect.x,
          y: R.y / cube._firstRect.y,
          z: R.z / cube._firstRect.z
        };
        cube.scale.set(scale.x, scale.y, scale.z);
        r = cube.rotation.y;
        cube._setRects();
        return cube.rotation.y = r;
      };
      cube.updateRect = function(newRect) {
        if (newRect) {
          cube._updateRect(newRect);
        }
        if (cube.rot === 90 || cube.rot === -90 || cube.rot === 270 || cube.rot === -270) {
          return cube.rect = {
            x: cube._rect.z,
            y: cube._rect.y,
            z: cube._rect.x
          };
        } else {
          return cube.rect = {
            x: cube._rect.x,
            y: cube._rect.y,
            z: cube._rect.z
          };
        }
      };
      cube.rotateLeft = function() {
        var _r, r;
        r = cube.rotation;
        _r = cube.hightlighter.rotation;
        if (cube.rot === 270) {
          r.y = 0;
          _r.y = 0;
          cube.rot = 0;
        } else {
          r.y += rad(90);
          _r.y += rad(90);
          cube.rot += 90;
        }
        return cube.updateRect();
      };
      cube.rotateRight = function() {
        var _r, r;
        r = cube.rotation;
        _r = cube.hightlighter.rotation;
        if (cube.rot === -270) {
          r.y = 0;
          _r.y = 0;
          cube.rot = 0;
        } else {
          r.y -= rad(90);
          _r.y -= rad(90);
          cube.rot -= 90;
        }
        return cube.updateRect();
      };
      if (callback) {
        return callback(cube);
      }
    });
  }
  return cube;
})();
