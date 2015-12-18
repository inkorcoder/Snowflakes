(ROOM = (size, texture)->
	textureLoader = new THREE.TextureLoader()
	texture = textureLoader.load( "textures/side.jpg" );
	texture.wrapS = THREE.RepeatWrapping;
	texture.wrapT = THREE.RepeatWrapping;
	texture.repeat.set( 4, 4 )
	texture.anisotropy = 16

	if size
		geometry = new THREE.BoxGeometry(size.x, size.y, size.z)
		material = new THREE.MeshPhongMaterial({
			side: THREE.BackSide
			map: texture
		})
		$('#roomLength').html size.z
		$('#roomHeight').html size.y
		$('#roomWidth').html size.x
		cube = new THREE.Mesh(geometry, material)
		cube._firstRect = {x:size.x, y:size.y, z:size.z}
		cube.rect = {x:size.x, y:size.y, z:size.z}
		# console.log cube.userData

		_geometry = new THREE.PlaneGeometry 100, 100, 10, 1
		_material = new THREE.MeshBasicMaterial {
			color: 0xffff00
			side: THREE.DoubleSide
			transparent: on
			opacity: 0
		}
		cube.setTexture = (path)->
			textureLoader = new THREE.TextureLoader()
			texture = textureLoader.load( path, ->
				texture.wrapS = THREE.RepeatWrapping;
				texture.wrapT = THREE.RepeatWrapping;
				texture.repeat.set( 4, 4 )
			);
			cube.material.map = texture
		cube._updateRect = (R)->
			scale = {
				x: R.x / cube._firstRect.x
				y: R.y / cube._firstRect.y
				z: R.z / cube._firstRect.z
			}
			cube.scale.set scale.x, scale.y, scale.z
			cube.rect = {x:R.x, y:R.y, z:R.z}
		cube.plane = new THREE.Mesh _geometry, _material
		scene.add cube.plane
	# cube.plane.rotation.x = rad 90
	# cube.plane.position.y = -cube.rect.y/2-0.1

	cube
)()
