scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(50, window.innerWidth / window.innerHeight, 0.1, 10000)


webglAvailable = ->
	canvas = undefined
	e = undefined
	try
		canvas = document.createElement('canvas')
		return ! !(window.WebGLRenderingContext and (canvas.getContext('webgl') or canvas.getContext('experimental-webgl')))
	catch _error
		e = _error
		return false
	return

if webglAvailable()
	renderer = new THREE.WebGLRenderer( { alpha: true, antialias: true } )
	renderer.setClearColor( 0x000000, 0 )
	renderer.setSize window.innerWidth, window.innerHeight
	document.getElementById('webglRender').appendChild renderer.domElement
	renderer.setPixelRatio window.devicePixelRatio
else
	alert 'Ваш браузер не поддерживает технологию WEBGL'



# M = new THREE.Mesh new THREE.SphereGeometry(0.1,10,10), new THREE.MeshNormalMaterial()
# scene.add M
room = new ROOM {
	x: parseFloat $('#roomLengthInput').val()
	z: parseFloat $('#roomWidthInput').val()
	y: parseFloat $('#roomHeightInput').val()
}, 'side.jpg'
scene.add room
updateRoomProperties()


OBJECTS = []
activeObject = null

window.currentZoom = 0
window.currentZoomOld = 0

lastObjsLength = 0

ZOOM =
	max: 60
	min: -40


stickness = 0.1
do updateSticknessVal

camera.position.z = room.rect.z/2*2
camera.position.x = room.rect.x/2*2
camera.position.y = room.rect.y

light = new THREE.AmbientLight 0x999999
scene.add light 

pointLight = new THREE.PointLight 0xffffff, 0.5, 50
pointLight.position.set( 0, 1.3, 0 );
scene.add( pointLight );
# pointLightHelper = new THREE.PointLightHelper( pointLight, 0.2 );
# scene.add( pointLightHelper );


control = new THREE.TransformControls( camera, renderer.domElement );
# control.addEventListener( 'change', render );

scene.add control

# axisHelper = new THREE.AxisHelper( 50 )
# scene.add( axisHelper )

controls = new THREE.OrbitControls( camera, renderer.domElement )
# console.log controls

# plane = new (THREE.Mesh)(new (THREE.PlaneGeometry)(2000, 2000, 18, 18), new (THREE.MeshBasicMaterial)(
#   color: 0x00ff00
#   opacity: 0.25
#   transparent: true))
# plane.visible = false
# scene.add plane

cameraFirstCoordinates = {
	position: new THREE.Vector3 camera.position.x, camera.position.y, camera.position.z
	rotation: camera.rotation.clone()
}

render = ->
	requestAnimationFrame render

	camera.updateProjectionMatrix();
	control.update()

	if room.plane
		room.plane.rotation.x = camera.rotation.x
		room.plane.rotation.y = camera.rotation.y
		room.plane.rotation.z = camera.rotation.z

	# if camera.fov is 20
	# 	for o in OBJECTS
	# 		o.hightlighter.visible = on
	# 		o.setTexture 'textures/hatch.jpg'
	# 		o.scale.set 0.98, 0.98, 0.98
	# else
	# 	for o in OBJECTS
	# 		o.hightlighter.visible = off
	# 		o.setTexture o.texturePath
	# 		o.scale.set 1,1,1

	for o in OBJECTS
		if o.position.y - (o.rect.y/2) < -room.rect.y/2
			o.position.y = -room.rect.y/2+(o.rect.y/2)

	# do frameFunction if frameFunction isnt undefined

	renderer.render scene, camera

render()