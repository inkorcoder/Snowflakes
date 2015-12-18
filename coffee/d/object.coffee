(OBJ = (model, size, modelTexture, callback)->

	cube = {}
	l = new THREE.JSONLoader()

	if model isnt undefined
		l.load 'models/'+model, (geo)->
			textureLoader = new THREE.TextureLoader()
			texture = textureLoader.load( "textures/"+modelTexture, ->
				texture.wrapS = THREE.RepeatWrapping;
				texture.wrapT = THREE.RepeatWrapping;
				# texture.repeat.set( 20, 20 )
				texture.anisotropy = 16
			);


			material = new THREE.MeshPhongMaterial({
				map: texture
				emissive: 0x000000
			})
			# mat.push(material)
			cube = new THREE.Mesh geo, material
			cube.texturePath = "textures/"+modelTexture
			cube.hightlighter = new THREE.Mesh geo, new THREE.MeshPhongMaterial
				side: THREE.BackSide
				color: 0x000000
			scene.add cube.hightlighter
			cube.hightlighter.visible = off

			cube.scale.set 1, 1, 1

			cube.collisions = {
				x: off, X: off
				y: off, Y: off
				z: off, Z: off
			}

			cube.setTexture = (path)->
				textureLoader = new THREE.TextureLoader()
				texture = textureLoader.load( path, ->
					texture.wrapS = THREE.RepeatWrapping;
					texture.wrapT = THREE.RepeatWrapping;
					# texture.repeat.set( 2, 2 )
				);
				console.log path
				cube.material.map = texture

			cube._setRects = (isFirst)->
				cube.rotation.y = 0
				bbox = new THREE.Box3().setFromObject cube
				size = {
					x: bbox.max.x-bbox.min.x
					y: bbox.max.y-bbox.min.y
					z: bbox.max.z-bbox.min.z
				}
				if isFirst then cube._firstRect = {x:size.x, y:size.y, z:size.z}
				cube._rect = {x:size.x, y:size.y, z:size.z}
				cube.rect = {x:size.x, y:size.y, z:size.z}
			cube._setRects on

			cube.rot = 0

			cube._updateRect = (R)->
				scale = {
					x: R.x / cube._firstRect.x
					y: R.y / cube._firstRect.y
					z: R.z / cube._firstRect.z
				}
				cube.scale.set scale.x, scale.y, scale.z
				r = cube.rotation.y
				cube._setRects()
				cube.rotation.y = r

			cube.updateRect = (newRect)->

				if newRect then cube._updateRect newRect

				if cube.rot is 90 or cube.rot is -90 or cube.rot is 270 or cube.rot is -270
					cube.rect = {x: cube._rect.z, y:cube._rect.y, z:cube._rect.x}
				else
					cube.rect = {x: cube._rect.x, y:cube._rect.y, z:cube._rect.z}

			cube.rotateLeft = ->
				r = cube.rotation
				_r = cube.hightlighter.rotation
				if cube.rot is 270
					r.y = 0
					_r.y = 0
					cube.rot = 0
				else
					r.y += rad 90
					_r.y += rad 90
					cube.rot += 90
				cube.updateRect()

			cube.rotateRight = ->
				r = cube.rotation
				_r = cube.hightlighter.rotation
				if cube.rot is -270
					r.y = 0
					_r.y = 0
					cube.rot = 0
				else
					r.y -= rad 90
					_r.y -= rad 90
					cube.rot -= 90
				cube.updateRect()

			callback(cube) if callback

	cube
)()
