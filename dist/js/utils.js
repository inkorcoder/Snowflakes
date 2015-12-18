var collision, createLine, deg, disableObjectControls, enableObjectControls, getBBox, getBBoxes, getPrtialRect, getXY, helpBox, helpBoxes, helpLine, message, rad, rand, serialize, setScale, setSliderScale;

helpLine = null;

helpBox = null;

helpBoxes = [];

deg = function(radians) {
  return radians * (180 / Math.PI);
};

rad = function(degrees) {
  return degrees * (Math.PI / 180);
};

rand = function(min, max) {
  return Math.random() * (max - min) + min;
};

createLine = function(vec1, vec2) {
  var geometry, material;
  scene.remove(helpLine);
  material = new THREE.LineBasicMaterial({
    color: 0x00ffff
  });
  geometry = new THREE.Geometry;
  geometry.vertices.push(vec1);
  geometry.vertices.push(vec2);
  helpLine = new THREE.Line(geometry, material);
  return scene.add(helpLine);
};

getBBox = function(obj, color) {
  scene.remove(helpBox);
  helpBox = new THREE.BoundingBoxHelper(obj, (color ? color : 0xff0000));
  helpBox.update();
  return scene.add(helpBox);
};

getBBoxes = function(arr) {
  var b, bb, j, k, len, len1, results;
  for (j = 0, len = helpBoxes.length; j < len; j++) {
    b = helpBoxes[j];
    scene.remove(b);
  }
  results = [];
  for (k = 0, len1 = arr.length; k < len1; k++) {
    b = arr[k];
    bb = new THREE.BoundingBoxHelper(b, 0x00ff00);
    bb.update();
    helpBoxes.push(bb);
    results.push(scene.add(bb));
  }
  return results;
};

getPrtialRect = function(obj) {
  return {
    x: obj.rect.x / 2,
    y: obj.rect.y / 2,
    z: obj.rect.z / 2
  };
};

collision = function(obj, objs) {
  var C, O, b, collisions, i, j, k, len, len1, o, results;
  O = obj;
  O.r = getPrtialRect(obj);
  O.p = obj.position;
  C = {
    p: control.position
  };
  for (j = 0, len = helpBoxes.length; j < len; j++) {
    b = helpBoxes[j];
    scene.remove(b);
  }
  helpBoxes = [];
  collisions = [];
  results = [];
  for (i = k = 0, len1 = objs.length; k < len1; i = ++k) {
    o = objs[i];
    if (O.uuid !== o.uuid) {
      o.r = getPrtialRect(o);
      o.p = o.position;
      O.collisions.x = O.p.x - O.r.x < o.p.x + o.r.x ? true : false;
      O.collisions.X = O.p.x + O.r.x > o.p.x - o.r.x ? true : false;
      O.collisions.y = O.p.y - O.r.y < o.p.y + o.r.y ? true : false;
      O.collisions.Y = O.p.y + O.r.y > o.p.y - o.r.y ? true : false;
      O.collisions.z = O.p.z - O.r.z < o.p.z + o.r.z ? true : false;
      O.collisions.Z = O.p.z + O.r.z > o.p.z - o.r.z ? true : false;
      if ((O.collisions.x && O.collisions.X) && (O.collisions.y && O.collisions.Y) && (O.collisions.z && O.collisions.Z)) {
        getBBox(O);
        collisions.push(o);
      }
      if (C.p.x - O.r.x < o.p.x + o.r.x + stickness && C.p.x > o.p.x && O.collisions.y && O.collisions.Y && O.collisions.z && O.collisions.Z) {
        O.p.x = o.p.x + O.r.x + o.r.x;
      }
      if (C.p.x + O.r.x > o.p.x - o.r.x - stickness && C.p.x < o.p.x && O.collisions.y && O.collisions.Y && O.collisions.z && O.collisions.Z) {
        O.p.x = o.p.x - O.r.x - o.r.x;
      }
      if (C.p.z - O.r.z < o.p.z + o.r.z + stickness && C.p.z > o.p.z && O.collisions.x && O.collisions.X && O.collisions.y && O.collisions.Y) {
        O.p.z = o.p.z + O.r.z + o.r.z;
      }
      if (C.p.z + O.r.z > o.p.z - o.r.z - stickness && C.p.z < o.p.z && O.collisions.x && O.collisions.X && O.collisions.y && O.collisions.Y) {
        O.p.z = o.p.z - O.r.z - o.r.z;
      }
      if (C.p.y - O.r.y < o.p.y + o.r.y + stickness && C.p.y > o.p.y && O.collisions.x && O.collisions.X && O.collisions.z && O.collisions.Z) {
        O.p.y = o.p.y + O.r.y + o.r.y;
      }
      if (C.p.y + O.r.y > o.p.y - o.r.y - stickness && C.p.y < o.p.y && O.collisions.x && O.collisions.X && O.collisions.z && O.collisions.Z) {
        O.p.y = o.p.y - O.r.y - o.r.y;
      }
    }
    if (i === objs.length - 1) {
      if (collisions.length > 0) {
        results.push(getBBoxes(collisions));
      } else {
        results.push(scene.remove(helpBox));
      }
    } else {
      results.push(void 0);
    }
  }
  return results;
};

getXY = function(e) {
  var intersects, mouse;
  mouse = getCoordinates(e);
  raycaster.setFromCamera(mouse, camera);
  intersects = raycaster.intersectObjects([room.plane]);
  return intersects[0].point;
};

enableObjectControls = function() {
  return $('#editObject, #deleteObject, #rotation, #scale').removeClass('disabled');
};

disableObjectControls = function() {
  $('#editObject, #deleteObject, #rotation, #scale').addClass('disabled');
  return $('.popup').removeClass('active');
};

message = function(text) {
  var elem;
  elem = $('<div/>').addClass('message').html(text);
  $('.page-wrapper').append(elem);
  return setTimeout(function() {
    elem.addClass('active');
    return setTimeout(function() {
      elem.removeClass('active');
      return setTimeout(function() {
        return elem.remove();
      }, 500);
    }, 4000);
  }, 100);
};

setSliderScale = function(val1, val2) {
  if (val1 > val2) {
    if (window.currentZoom < ZOOM.max) {
      controls.zoomIn();
      return controls.zoomIn();
    }
  } else {
    if (window.currentZoom > ZOOM.min) {
      controls.zoomOut();
      return controls.zoomOut();
    }
  }
};

setScale = function(val) {
  return console.log(val);
};

serialize = function(mixed_val) {
  var class_name, i, idxobj, map, prop, props, ser;
  switch (typeof mixed_val) {
    case "number":
      if (isNaN(mixed_val) || !isFinite(mixed_val)) {
        return false;
      } else {
        return (Math.floor(mixed_val) === mixed_val ? "i" : "d") + ":" + mixed_val + ";";
      }
      break;
    case "string":
      return "s:" + mixed_val.length + ":\"" + mixed_val + "\";";
    case "boolean":
      return "b:" + (mixed_val ? "1" : "0") + ";";
    case "object":
      if (mixed_val == null) {
        return "N;";
      } else if (mixed_val instanceof Array) {
        idxobj = {
          idx: -1
        };
        map = [];
        i = 0;
        while (i < mixed_val.length) {
          idxobj.idx++;
          ser = serialize(mixed_val[i]);
          if (ser) {
            map.push(serialize(idxobj.idx) + ser);
          }
          i++;
        }
        return "a:" + mixed_val.length + ":{" + map.join("") + "}";
      } else {
        class_name = get_class(mixed_val);
        if (class_name === undefined) {
          return false;
        }
        props = new Array();
        for (prop in mixed_val) {
          ser = serialize(mixed_val[prop]);
          if (ser) {
            props.push(serialize(prop) + ser);
          }
        }
        return "O:" + class_name.length + ":\"" + class_name + "\":" + props.length + ":{" + props.join("") + "}";
      }
      break;
    case "undefined":
      return "N;";
  }
  return false;
};
