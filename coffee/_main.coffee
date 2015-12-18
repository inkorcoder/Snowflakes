# ----------------------------------------------------------
# HELPERS
# ----------------------------------------------------------

getRandomInt = (min, max)->
	rand = Math.floor(Math.random() * (max - min + 1)) + min
	return rand

orbit = (radius, scene) ->
	this.radius = radius
	# this.draw = (scene)->
	og = new THREE.Geometry()
	om = new THREE.ParticleBasicMaterial
		color: 0x222222
		size: 1
		sizeAttenuation: false
	for i in [0...50000]
		v = new THREE.Vector3()
		v.x = Math.sin(Math.PI/180*i)*this.radius
		v.z = Math.cos(Math.PI/180*i)*this.radius
		og.vertices.push v
	obj = new THREE.ParticleSystem og, om
	scene.add obj


# planet = (size1, size2, size3, texture, color)->
# 	planetGeo 			= new THREE.SphereGeometry size1, size2, size3
# 	planetTexture 	= new THREE.ImageUtils.loadTexture texture
# 	planetTexture.anisotropy = 12
# 	planetMat 			= new THREE.MeshBasicMaterial
# 		map: planetTexture
# 		color: color
# 	planet 					= new THREE.Mesh planetGeo, planetMat
# 	return
# ----------------------------------------------------------
# SCRIPT
# ----------------------------------------------------------

BODY = document.body

# BODY.onload = ->

container = document.createElement 'div'
BODY.appendChild container

W = parseInt window.innerWidth
H = parseInt window.innerHeight

CAMERA 	= new THREE.PerspectiveCamera 45, W/H, 1, 1000000
CAMERA.position.z = 5000

SCENE 	= new THREE.Scene()


LIGHT = new THREE.PointLight 0xffffff,1.4,35000
LIGHT.position.set 0, 0, 0
LIGHT.castShadow = true
LIGHT.shadowMapWidth = 2048
LIGHT.shadowMapHeight = 2048
SCENE.add LIGHT
# ----------------------------------------------------------
# PARTICULAR SYSTEM
# ----------------------------------------------------------

opacities = [
	0x555555,0x666666,0x777777,0x888888,
	0x999999,0xaaaaaa,0xbbbbbb,0xcccccc
]
# STARS GEOMETRY
starsGeo = new THREE.Geometry()
starsMat = new THREE.PointCloudMaterial
	color: 0x444444
	size: 1
	opacity: 0.5
	sizeAttenuation: false

for i in [0...45000]
	v = new THREE.Vector3()
	v.x = Math.random()*2-1
	v.y = Math.random()*2-1
	v.z = Math.random()*2-1
	v.multiplyScalar 6000
	starsGeo.vertices.push v

STARS = new THREE.PointCloud starsGeo, starsMat
STARS.scale.set 100, 100, 100
SCENE.add STARS

# STARS2 GEOMETRY
stars2Geo = new THREE.Geometry()
stars2Mat = new THREE.PointCloudMaterial
	color: 0x999999
	size: 1
	opacity: 0.5
	sizeAttenuation: false

for i in [0...10000]
	v = new THREE.Vector3()
	v.x = Math.random()*2-1
	v.y = Math.random()*2-1
	v.z = Math.random()*2-1
	v.multiplyScalar 6000
	stars2Geo.vertices.push v

STARS2 = new THREE.PointCloud stars2Geo, stars2Mat
STARS2.scale.set 100, 100, 100
SCENE.add STARS2

# --------------------------------------------------------
# PLANETS
# --------------------------------------------------------

# ambient = new THREE.AmbientLight 0x222222
# SCENE.add ambient

# SUN
# sun = planet 2300, 80, 80, 'img/sun.jpg', 0xffffff
sunGeo 			= new THREE.SphereGeometry 1300, 80, 80
sunTexture 	= new THREE.ImageUtils.loadTexture 'img/sun.jpg'
sunTexture.anisotropy = 12
sunMat 			= new THREE.MeshBasicMaterial
	map: sunTexture
	color: 0xffffff
sun 					= new THREE.Mesh sunGeo, sunMat
SCENE.add sun

# MERCURY
# earth = planet 30, 20, 20, 'img/earthmap1k.jpg', 0xffffff
mercuryGeo 			= new THREE.SphereGeometry 50, 20, 20
mercuryTexture 	= new THREE.ImageUtils.loadTexture 'img/mercury.jpg'
mercuryTexture.anisotropy = 12
mercuryMat 			= new THREE.MeshPhongMaterial
	map: mercuryTexture
mercury 					= new THREE.Mesh mercuryGeo, mercuryMat
SCENE.add mercury

# VENUS
# earth = planet 30, 20, 20, 'img/earthmap1k.jpg', 0xffffff
venusGeo 			= new THREE.SphereGeometry 70, 20, 20
venusTexture 	= new THREE.ImageUtils.loadTexture 'img/venus.jpg'
venusTexture.anisotropy = 12
venusMat 			= new THREE.MeshPhongMaterial
	map: venusTexture
venus 					= new THREE.Mesh venusGeo, venusMat
SCENE.add venus

# EARH
# earth = planet 30, 20, 20, 'img/earthmap1k.jpg', 0xffffff
earthGeo 			= new THREE.SphereGeometry 100, 20, 20
earthTexture 	= new THREE.ImageUtils.loadTexture 'img/earth.jpg'
earthTexture.anisotropy = 12
earthMat 			= new THREE.MeshPhongMaterial
	map: earthTexture
earth 					= new THREE.Mesh earthGeo, earthMat
SCENE.add earth

# MARS
# earth = planet 30, 20, 20, 'img/earthmap1k.jpg', 0xffffff
marsGeo 			= new THREE.SphereGeometry 70, 20, 20
marsTexture 	= new THREE.ImageUtils.loadTexture 'img/mars.gif'
marsTexture.anisotropy = 12
marsMat 			= new THREE.MeshPhongMaterial
	map: marsTexture
mars 					= new THREE.Mesh marsGeo, marsMat
SCENE.add mars

# JUPITER
# earth = planet 30, 20, 20, 'img/earthmap1k.jpg', 0xffffff
jupiterGeo 			= new THREE.SphereGeometry 270, 50, 50
jupiterTexture 	= new THREE.ImageUtils.loadTexture 'img/jupiter.jpg'
jupiterTexture.anisotropy = 12
jupiterMat 			= new THREE.MeshPhongMaterial
	map: jupiterTexture
jupiter 					= new THREE.Mesh jupiterGeo, jupiterMat
jupiter.castShadow = true
SCENE.add jupiter

# SATURN
# earth = planet 30, 20, 20, 'img/earthmap1k.jpg', 0xffffff
saturnGeo 			= new THREE.SphereGeometry 170, 50, 50
saturnTexture 	= new THREE.ImageUtils.loadTexture 'img/saturn.jpg'
saturnTexture.anisotropy = 12
saturnMat 			= new THREE.MeshPhongMaterial
	map: saturnTexture
saturn 					= new THREE.Mesh saturnGeo, saturnMat
SCENE.add saturn

# URAN
# earth = planet 30, 20, 20, 'img/earthmap1k.jpg', 0xffffff
uranGeo 			= new THREE.SphereGeometry 100, 50, 50
uranTexture 	= new THREE.ImageUtils.loadTexture 'img/neptun.jpg'
uranTexture.anisotropy = 12
uranMat 			= new THREE.MeshPhongMaterial
	map: uranTexture
uran 					= new THREE.Mesh uranGeo, uranMat
SCENE.add uran

# NEPTUN
neptunGeo 			= new THREE.SphereGeometry 40, 20, 20
neptunTexture 	= new THREE.ImageUtils.loadTexture 'img/neptun.jpg'
neptunTexture.anisotropy = 12
neptunMat 			= new THREE.MeshPhongMaterial
	map: neptunTexture
	color: 0x888888
neptun 					= new THREE.Mesh neptunGeo, neptunMat
SCENE.add neptun

# PLUTON
plutonGeo 			= new THREE.SphereGeometry 30, 20, 20
plutonTexture 	= new THREE.ImageUtils.loadTexture 'img/pluton.jpg'
plutonTexture.anisotropy = 12
plutonMat 			= new THREE.MeshPhongMaterial
	map: plutonTexture
pluton 					= new THREE.Mesh plutonGeo, plutonMat
SCENE.add pluton

# --------------------------------------------------------
# WEBGL / CANVAS
# --------------------------------------------------------


webglAvailable = ->
	try
		canvas = document.createElement 'canvas'
		return !!(window.WebGLRenderingContext && (canvas.getContext( 'webgl' ) || canvas.getContext( 'experimental-webgl' ) ))
	catch e
		return false

if webglAvailable()
	RENDER = new THREE.WebGLRenderer()
else
	alert 'Your browser doesn`t support WEBGL'

RENDER.setSize W, H

container.appendChild RENDER.domElement

t = 0
x = 0
y = 0

document.addEventListener 'mousemove', (e)->
	x = parseInt e.offsetX
	y = parseInt e.offsetY

CAMERA.position.y = 13000
# CAMERA.rotation.z = -Math.PI/10

# orbits
orbit 4000, SCENE
orbit 5500, SCENE
orbit 7000, SCENE
orbit 8000, SCENE
orbit 12000, SCENE
orbit 15000, SCENE
orbit 17000, SCENE
orbit 18000, SCENE
orbit 20000, SCENE




# -------------------------------------------------------
# ANIMATE
# -------------------------------------------------------

animate = ->
	requestAnimationFrame animate

	# sun
	sun.rotation.y += 0.001

	# mercury
	mercury.position.x = Math.sin(t*0.2/4)*4000
	mercury.position.z = Math.cos(t*0.2/4)*4000

	# venus
	venus.position.x = Math.sin(-t*0.17/4)*5500
	venus.position.z = Math.cos(-t*0.17/4)*5500

	# earth
	earth.position.x = Math.sin(t*0.15/4)*7000
	earth.position.z = Math.cos(t*0.15/4)*7000

	# mars
	mars.position.x = Math.sin(t*0.12/4)*8000
	mars.position.z = Math.cos(t*0.12/4)*8000

	# jupiter
	jupiter.position.x = Math.sin(-t*0.1/4)*12000
	jupiter.position.z = Math.cos(-t*0.1/4)*12000

	# saturn
	saturn.position.x = Math.sin(t*0.09/4)*15000
	saturn.position.z = Math.cos(t*0.09/4)*15000

	# uran
	uran.position.x = Math.sin(-t*0.08/4)*17000
	uran.position.z = Math.cos(-t*0.08/4)*17000

	# neptun
	neptun.position.x = Math.sin(t*0.07/4)*18000
	neptun.position.z = Math.cos(t*0.07/4)*18000

	# pluton
	pluton.position.x = Math.sin(t*0.06/4)*20000
	pluton.position.z = Math.cos(t*0.06/4)*20000


	# CAMERA.position.x = -x*100
	CAMERA.position.y = y*100
	# CAMERA.position.z = y
	CAMERA.lookAt SCENE.position
	t += Math.PI/180*2


	RENDER.render SCENE, CAMERA
animate()