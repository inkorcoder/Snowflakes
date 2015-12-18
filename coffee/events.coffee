window.onresize = ->
	camera.aspect = window.innerWidth / window.innerHeight
	camera.updateProjectionMatrix()
	renderer.setSize( window.innerWidth, window.innerHeight )

raycaster = new THREE.Raycaster();

getCoordinates = (ev)->
	mouse = new THREE.Vector2();
	if ev.originalEvent.touches isnt undefined
		mouse.y = -(ev.originalEvent.touches[0].pageY / renderer.domElement.height) * 2 + 1
		mouse.x = (ev.originalEvent.touches[0].pageX / renderer.domElement.width) * 2 - 1
	else
		mouse.y = -(ev.clientY / renderer.domElement.height) * 2 + 1
		mouse.x = (ev.clientX / renderer.domElement.width) * 2 - 1
	mouse


$ '#reload'
	.click (e)->
		e.preventDefault()
		location.reload()


# clickHandler = (event)->
# 	event.preventDefault()
# 	event.stopPropagation()
# 	# controls.enabled = on
# 	mouse = getCoordinates event
# 	raycaster.setFromCamera mouse, camera
# 	intersects = raycaster.intersectObjects [ground]
# 	if intersects.length > 0
# 		# console.log intersects[0].point
# 		for i in [0...20]
# 			tree = new THREE.Mesh treeGeometry, treeMaterial
# 			scene.add tree
# 			tree.position.x = intersects[0].point.x+rand -1,1
# 			tree.position.y = intersects[0].point.y
# 			tree.position.z = intersects[0].point.z+rand -1,1
# 			treesCoordinates.push [
# 				intersects[0].point.x+rand -1,1
# 				intersects[0].point.y
# 				intersects[0].point.z+rand -1,1
# 			]


# $(document).on 'mousedown touchstart', 'canvas', ->
# 	$(document).on 'mousemove touchmove', clickHandler
# 	$(document).on 'mouseup touchend', ->
# 		$(document).off 'mousemove touchmove'


