scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 0.1, 1000)


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



# M = new THRE

OBJECTS = []
activeObject = null

window.currentZoom = 0
window.currentZoomOld = 0

lastObjsLength = 0

ZOOM =
	max: 60000
	min: -40000

snowSpeed = 0.01

cube = new THREE.Mesh(
		new THREE.BoxGeometry(1,1,1),
		new THREE.MeshNormalMaterial({
			transparent: on
			opacity: 0
		})
	)
scene.add(
	cube
)
cube.position.x = 0
cube.position.y = 8
cube.position.z = 20

CATCHED = 0
UNCATCHED = 0


jsonLoader = new THREE.JSONLoader()
textureLoader = new THREE.TextureLoader()

treeGeometry= {}
treeMaterial = {}
ground = {}

jsonLoader.load 'models/CartoonTree.js', (geo)->
	treeGeometry = geo
	texture = textureLoader.load( "textures/elka.jpg", ->
		texture.wrapS = THREE.RepeatWrapping;
		texture.wrapT = THREE.RepeatWrapping;
		texture.repeat.set( 4, 4 )
		# texture.anisotropy = 16
	);
	treeMaterial = new THREE.MeshPhongMaterial({
		map: texture
		emissive: 0x000000
	})
	x = 0
	y = 0
	z = 0
	i = 0
	arr = []

	# ii=0
	# for c in treesCoordinates
	# 	if i is 0 then arr.push new Array()
	# 	arr[ii][i] = c
	# 	i++
	# 	if i is 3 then i = 0
	# 	if i is 0 then ii++
	# # console.log arr
	# for t in arr
	# 	tree = new Tree()
	# 	tree.position.x = t[0]
	# 	tree.position.y = t[1]
	# 	tree.position.z = t[2]
	# delete treesCoordinates




skyTexture = textureLoader.load( "textures/sky.jpg", ->
	# skyTexture.wrapS = THREE.RepeatWrapping;
	# skyTexture.wrapT = THREE.RepeatWrapping;
	# skyTexture.repeat.set( 1, 2 )
	# skyTexture.anisotropy = 16
);
snowTexture = textureLoader.load( "textures/snow.png", ->
	# skyTexture.wrapS = THREE.RepeatWrapping;
	# skyTexture.wrapT = THREE.RepeatWrapping;
	# skyTexture.repeat.set( 1, 2 )
	skyTexture.anisotropy = 16
);
sky = new THREE.Mesh(
	new THREE.SphereGeometry(50,50,50)
	new THREE.MeshPhongMaterial({
		color: 0xffffff
		emissive: 0x000000
		map: skyTexture
		side: THREE.BackSide
	})
)
scene.add sky





og = new THREE.Geometry()
og2 = new THREE.Geometry()
om = new THREE.PointsMaterial
	color: 0x99bbdd
	size: 1
	sizeAttenuation: off
om2 = new THREE.PointsMaterial
	color: 0x225599
	size: 1
	sizeAttenuation: off
	# map: snowTexture

for i in [0...10000]
	v = new THREE.Vector3()
	v.x = rand -30, 30
	v.y = rand 0, 20
	v.z = rand -20, 20
	og.vertices.push v
obj = new THREE.Points og, om
scene.add obj

for i in [0...40000]
	v = new THREE.Vector3()
	v.x = rand -30, 30
	v.y = rand 0, 20
	v.z = rand -20, 20
	og2.vertices.push v
obj2 = new THREE.Points og2, om2
scene.add obj2
# console.log obj.geometry.vertices

jsonLoader.load 'models/ground.js', (geo)->
	texture = textureLoader.load( "textures/ttt.jpg", ->
		texture.wrapS = THREE.RepeatWrapping;
		texture.wrapT = THREE.RepeatWrapping;
		# texture.repeat.set( 4, 4 )
		# texture.anisotropy = 16
	);
	mat = new THREE.MeshPhongMaterial({
		map: texture
		emissive: 0x000000
	})
	ground = new THREE.Mesh geo, mat
	ground.scale.set 50,50,50
	ground.position.y = -0.1
	ground.rotation.y = rad -90
	scene.add ground

snowball = {}

snowGeo = null
snowMat = new THREE.MeshPhongMaterial({
	side: THREE.DoubleSide
	color: 0xbbccdd
	emissive: 0x999999
})

jsonLoader.load 'models/snow.js', (geo)->
	snowGeo = geo
	mat = new THREE.MeshPhongMaterial({
		# map: texture
		side: THREE.DoubleSide
		color: 0xddeeff
		emissive: 0x999999
	})
	snowball = new THREE.Mesh geo, mat
	scene.add snowball
	snowball.scale.set 0.5, 0.5, 0.5
	snowball.isAnimated = off


jsonLoader.load 'models/house.js', (geo)->
	texture = textureLoader.load( "textures/house.jpg", ->

	);
	mat = new THREE.MeshPhongMaterial({
		map: texture
		# side: THREE.DoubleSide
		color: 0xddeeff
		emissive: 0x000000
	})
	house = new THREE.Mesh geo, mat
	house.position.y = 6
	house.position.z = -32
	house.rotation.y = -1.6
	scene.add house
	house.scale.set 3,3,3
	# snowball.isAnimated = off


SNOW = []
lastSnowRand = 0
addSnow = ->
	ar = [-6.8,0,6.8]
	r = parseInt(rand(0,2.9))
	if r isnt lastSnowRand
		snow = new THREE.Mesh snowGeo, snowMat
		scene.add snow
		snow.position.z = snowball.position.z-10
		snow.position.y = snowball.position.y
		snow.position.x = ar[r]
		snow.scale.set 0.4, 0.4, 0.4
		SNOW.push snow
		lastSnowRand = r
	# console.log snow.position


light = new THREE.AmbientLight 0x000000
scene.add light 

pointLight = new THREE.PointLight 0xbbddff, 1, 60
pointLight.position.set( 0, 50, -10 );
scene.add( pointLight );
# pointLightHelper = new THREE.PointLightHelper( pointLight, 0.2 );
# scene.add( pointLightHelper );


# control = new THREE.TransformControls( camera, renderer.domElement );
# control.addEventListener( 'change', render );

# scene.add control

# axisHelper = new THREE.AxisHelper( 50 )
# scene.add( axisHelper )

# controls = new THREE.OrbitControls( camera, renderer.domElement )
# console.log controls
waterTexture = textureLoader.load( "textures/water.jpg", ->
	waterTexture.wrapS = THREE.RepeatWrapping;
	waterTexture.wrapT = THREE.RepeatWrapping;
	waterTexture.repeat.set( 1, 2 )
	waterTexture.anisotropy = 16
);
plane = new THREE.Mesh(
	new THREE.PlaneGeometry(100, 100, 10)
	new THREE.MeshPhongMaterial({
		color: 0x444499
		emissive: 0x000000
		map: waterTexture
	})
)
plane.position.y = 1.5
plane.rotation.x = rad -90
# plane.visible = false
scene.add plane


camera.position.y = 30
camera.position.z = 35


clock = new THREE.Clock()
clock.start()


keys = new THREEx.KeyboardState()

# snowball.position.y = camera.position.y

endOfGame = ->
	$ '#total'
		.html "
			catched: #{CATCHED} missed: #{UNCATCHED} <br>
			(#{((CATCHED/UNCATCHED)*100).toFixed(1)}%)
			<small>looser :)</small>
		"
	$ '#popup'
		.fadeIn 2000



delta = 0
anim = 0
render = ->
	requestAnimationFrame render

	if camera.position.z > -10
		camera.position.z -= 0.01


	if camera.position.y > cube.position.y+1 then camera.position.y -= 0.005


	for v,i in obj.geometry.vertices
		# obj.geometry.vertices[i] = new THREE.Vector3 v.x, v.y-0.1, v.z
		v.y -= snowSpeed
		if rand(-1,1) > 0
			v.x += (Math.sin delta/50)/50
		else 
			v.x += (Math.cos delta/50)/50
		if v.y < 0 then v.y = 20

	for v,i in obj2.geometry.vertices
		# obj.geometry.vertices[i] = new THREE.Vector3 v.x, v.y-0.1, v.z
		v.y -= snowSpeed
		if rand(-1,1) > 0
			v.x += (Math.sin delta/50)/50
		else 
			v.x += (Math.cos delta/50)/50
		if v.y < 0 then v.y = 20

	obj.geometry.verticesNeedUpdate = on
	obj.geometry.elementsNeedUpdate = on
	obj2.geometry.verticesNeedUpdate = on
	obj2.geometry.elementsNeedUpdate = on
	camera.lookAt cube.position

	if snowball
		# snowball.position.x = camera.position.x
		if camera.position.z > -10
			snowball.position.z = cube.position.z+2
			snowball.position.y = cube.position.y+((Math.sin delta/10))
			snowball.rotation.x += if (snowball.isAnimated is 'left') or (snowball.isAnimated is 'right') then 0.2 else 0.1
			snowball.rotation.y += if (snowball.isAnimated is 'left') or (snowball.isAnimated is 'right') then 0.3 else 0.2
			snowball.rotation.z += 0.01
		else
			snowball.rotation.x = -1.6
			snowball.rotation.y = 0
			snowball.rotation.z = 0
			endOfGame()

	for s in SNOW
		P = snowball.position
		p = s.position
		ss = snowball.scale.x
		if s.position.z > snowball.position.z+ss
			s.visible = off
			if !s.visible and !s.checked
				s.checked = on
				UNCATCHED++
		if s.visible
			s.position.z += (delta/6000)
			s.rotation.z += 0.01
			s.rotation.x += 0.1
			if (p.x > P.x-ss) and (p.x < P.x+ss) and (p.z > P.z-ss) and (p.z < P.z+ss)
				s.visible = off
				sc = snowball.scale.x + 0.001
				snowball.scale.set sc,sc,sc
				CATCHED++



	if (keys.pressed 'left') and (snowball.position.x > -5)
		# snowball.position.x -= 0.1
		if snowball.isAnimated is off
			snowball.isAnimated = 'left'
			snowball.frame = 0
	if (keys.pressed 'right')  and (snowball.position.x < 5)
		# snowball.position.x += 0.1
		if snowball.isAnimated is off
			snowball.isAnimated = 'right'
			snowball.frame = 0

	if snowball.isAnimated is 'left'
		snowball.position.x -= (Math.sin snowball.frame)
		snowball.frame += 0.3
		if snowball.frame > 3.2
			snowball.frame = 0
			snowball.isAnimated = off

	if snowball.isAnimated is 'right'
		snowball.position.x += (Math.sin snowball.frame)
		snowball.frame += 0.3
		if snowball.frame > 3.2
			snowball.frame = 0
			snowball.isAnimated = off


	if cube.position.z > -24
		cube.position.z -= 0.01

	plane.position.y += (Math.sin delta/50)/500

	leftStr = "["
	for _s in [0..48]
		leftStr += if snowball.position.z+10 >= _s then '|' else '.'
	leftStr += "]"


	$('#catched').html CATCHED+'/'+UNCATCHED
	$('#left').html snowball.position.z
	$('#left2').html leftStr

	# if parseFloat (Math.sin anim/100).toFixed(1) is 0.9 then addSnow()
	# console.log (Math.sin anim/100).toFixed(1)

	if delta > 4000
		_r = 0.5
	else if delta > 3000
		_r = 2
	else if delta > 2000
		_r = 8
	else if delta > 1000
		_r = 16
	else
		_r = 32

	if (parseInt(rand(-_r,_r)) is 0) and snowball.position.z > -20 then addSnow()
	# console.log delta
	delta += 1
	anim++
	if anim > 180 then anim = 0

	camera.updateProjectionMatrix();
	# control.update()

	renderer.render scene, camera

render()