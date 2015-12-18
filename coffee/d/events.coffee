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

clickHandler = (event)->
	event.preventDefault()
	event.stopPropagation()
	# controls.enabled = on
	mouse = getCoordinates event
	raycaster.setFromCamera mouse, camera
	intersects = raycaster.intersectObjects OBJECTS
	if intersects.length > 0
	# 	controls.enabled = off
		control.attach intersects[0].object
	else
		control.detach()
	if control.object
		collision control.object, OBJECTS
		enableObjectControls()
		if camera.fov is 1
			$(document).on 'mousemove touchmove', (e)->
				e.preventDefault()
				mouse = getCoordinates e
				pos = getXY e
				control.object.position.x = pos.x
				control.object.position.y = pos.y
				control.object.position.z = pos.z
				controlsUpdate pos
	else
		disableObjectControls()
	# intersects = raycaster.intersectObjects [control.object]
	# if intersects.length > 0
	# 	controls.enabled = off
		# intersects[0].object.material.transparent = on
		# intersects[0].object.material.opacity = 0.5
		# activeObject = intersects[0].object
		# $(document).on 'mousemove touchmove', (e)->
		# 	mouse = getCoordinates e
			# console.log mouse
			# activeObject.position.x = mouse.x
			# activeObject.position.z = mouse.y



$(document).on 'mousedown touchstart', 'canvas', clickHandler


# $(document).on 'mousemove touchmove', (e)->
# 	e.preventDefault()


$(document).on 'mouseup touchend', ->
	# disableObjectControls()
	$(document).off 'mousemove touchmove'




$ '.subcategories ul li'
	.mousedown (e)->
		e.preventDefault()
		size = {
			x: $(this).data 'x'
			y: $(this).data 'y'
			z: $(this).data 'z'
		}
		$t = $ this
		# console.log size
		object = new OBJ $(this).data('objectmodel'), size, $(this).data('texture'), (cube)->
			# console.log cube
			$ '#objectPreview img'
				.attr 'src', $t.data 'picture'
			activeObject = cube
			control.attach activeObject
			OBJECTS.push cube
			pos = getXY e
			activeObject.position.x = pos.x
			activeObject.position.y = pos.y
			activeObject.position.z = pos.z
			scene.add cube

			if camera.fov is 1
				for o in OBJECTS
					o.hightlighter.visible = on
					o.setTexture 'textures/hatch.jpg'
					o.scale.set 0.97, 3, 0.97

			enableObjectControls()

			$(document).on 'mousemove touchmove', (e)->
				e.preventDefault()
				mouse = getCoordinates e
				pos = getXY e
				activeObject.position.x = pos.x
				activeObject.position.y = pos.y
				activeObject.position.z = pos.z
				controlsUpdate pos
			# console.log pos





controlsUpdate = (pos)->
	# console.log pos
	box = new THREE.Box3().setFromObject( control.object );
	# x --|->
	if pos.x + (control.object.rect.x/2) > room.rect.x/2
		control.object.position.x = room.rect.x/2-(control.object.rect.x/2)
	# x <-|--
	if pos.x - (control.object.rect.x/2) < -room.rect.x/2
		control.object.position.x = -room.rect.x/2+(control.object.rect.x/2)
	# y --|->
	if pos.y + (control.object.rect.y/2) > room.rect.y/2
		control.object.position.y = room.rect.y/2-(control.object.rect.y/2)
	# y <-|--
	if pos.y - (control.object.rect.y/2) < -room.rect.y/2
		control.object.position.y = -room.rect.y/2+(control.object.rect.y/2)
	# z --|->
	if pos.z + (control.object.rect.z/2) > room.rect.z/2
		control.object.position.z = room.rect.z/2-(control.object.rect.z/2)
	# z <-|--
	if pos.z - (control.object.rect.z/2) < -room.rect.z/2
		control.object.position.z = -room.rect.z/2+(control.object.rect.z/2)

	collision control.object, OBJECTS

	control.object.hightlighter.position.x = control.object.position.x
	control.object.hightlighter.position.y = control.object.position.y-0.1
	control.object.hightlighter.position.z = control.object.position.z


$('#rotateLeft').click (e)->
	e.preventDefault()
	control.object.rotateLeft()
	collision control.object, OBJECTS
	# control.object.rotation.y += rad 90
	# control.object.updateRect()

$('#rotateRight').click (e)->
	e.preventDefault()
	control.object.rotateRight()
	collision control.object, OBJECTS
	# control.object.rotation.y -= rad 90
	# control.object.updateRect()


updateRangeSlider = (inSlider)->
	if inSlider
		r = parseInt window.range.get()
		console.log window.currentZoomOld, parseInt window.range.get()
		if r > 0
			if window.currentZoomOld > r then controls.zoomOut() else controls.zoomIn()
		else
			if window.currentZoomOld < r then controls.zoomOut() else controls.zoomIn()
	else
		window.range.set window.currentZoom+40

$ '.close-popup'
	.click (e)->
		e.preventDefault()
		# $ '#'+$(this).data 'close'
		# 	.removeClass 'active'
		$ '.popup'
			.removeClass 'active'
		controls.enabled = on
		$('#enableControls').addClass 'active'



$ '#editObject'
	.click (e)->
		e.preventDefault()
		if !$(this).hasClass 'disabled'
			$ '.popup'
				.removeClass 'active'
			$('#objectLength').val control.object._rect.x.toFixed 2
			$('#objectWidth').val control.object._rect.y.toFixed 2
			$('#objectHeight').val control.object._rect.z.toFixed 2
			$('#propertiesPopup')
				.addClass 'active'
			controls.enabled = off
			$('#enableControls').removeClass 'active'

$ '#deleteObject'
	.click (e)->
		e.preventDefault()
		if !$(this).hasClass 'disabled'
			for o,i in OBJECTS
				if o.uuid is control.object.uuid
					scene.remove o
					OBJECTS.splice i,1
					control.detach o

$ '#objectLength, #objectWidth, #objectHeight'
	.keyup (e)->
		setTimeout ->
			newRect = {
				x: if $('#objectLength').val().trim() is '' then control.object.rect.x else parseFloat $('#objectLength').val().trim()
				y: if $('#objectWidth').val().trim() is '' then control.object.rect.y else parseFloat $('#objectWidth').val().trim()
				z: if $('#objectHeight').val().trim() is '' then control.object.rect.z else parseFloat $('#objectHeight').val().trim()
			}
			control.object.updateRect newRect
		, 1000
		# console.log newRect


$ '#sticknessUp'
	.click (e)->
		e.preventDefault()
		if stickness < 0.45
			stickness += 0.05
		updateSticknessVal()

$ '#sticknessDown'
	.click (e)->
		e.preventDefault()
		if stickness > 0.1
			stickness -= 0.05
		updateSticknessVal()

updateSticknessVal = ->
	$('#sticknessValue').html Math.round(stickness * 100) / 100



$ '#defaultView, #startView'
	.click (e)->
		# e.preventDefault()
		for c in control.children[0].children[0].children
			c.scale.set 1,1,1
			c.visible = on
		controls.enabled = on
		control.enabled = on
		controls.reset()
		camera.fov = 50
		for o in OBJECTS
			o.hightlighter.visible = off
			o.setTexture o.texturePath
			o.scale.set 1,1,1
		control.enpose()
		pointLight.visible = on
		light.color.setHex 0x999999
			# console.log o.texturePath
		# window.currentZoom = 0
		# window.range.set -currentZoom

$ '#topView'
	.click (e)->
		# e.preventDefault()
		controls.enabled = off
		camera.fov = 1
		camera.position.y = 500
		camera.position.z = 0
		camera.position.x = 0
		camera.lookAt new THREE.Vector3 0,0,0
		# camera.rotation.y = 1.3
		for o in OBJECTS
			o.position.y = -o.rect.y/2
		# if camera.fov is 20
		for o in OBJECTS
			o.hightlighter.visible = on
			o.setTexture 'textures/hatch.jpg'
			o.scale.set 0.97, 3, 0.97
		for c, i in control.children[0].children[0].children
			c.visible = off
		control.dispose()
		room.plane.position.y = -room.rect.y/2+0.1
		pointLight.visible = off
		light.color.setHex 0xffffff


$ '[data-texture]'
	.click (e)->
		e.preventDefault()
		$(this).siblings().removeClass 'active'
		$(this).addClass 'active'
		control.object.setTexture $(this).data 'texture'


$ '#enableControls'
	.click (e)->
		e.preventDefault()
		$(this).toggleClass 'active'
		controls.enabled = if $(this).hasClass 'active' then on else off



#Запустить отображение в полноэкранном режиме

launchFullScreen = (element) ->
	if element.requestFullScreen
		element.requestFullScreen()
	else if element.mozRequestFullScreen
		element.mozRequestFullScreen()
	else if element.webkitRequestFullScreen
		element.webkitRequestFullScreen()
	return

# Выход из полноэкранного режима

cancelFullscreen = ->
	if document.cancelFullScreen
		document.cancelFullScreen()
	else if document.mozCancelFullScreen
		document.mozCancelFullScreen()
	else if document.webkitCancelFullScreen
		document.webkitCancelFullScreen()
	return

$ '#fullscreen'
	.click (e)->
		e.preventDefault()
		launchFullScreen document.getElementById("webglRender")


updateRoomProperties = ->
	room._updateRect {
		x: parseFloat $('#roomLengthInput').val()
		z: parseFloat $('#roomWidthInput').val()
		y: parseFloat $('#roomHeightInput').val()
	}
	$('#roomLength').html $('#roomLengthInput').val()
	$('#roomWidth').html $('#roomWidthInput').val()
	$('#roomHeight').html $('#roomHeightInput').val()

$ '#roomLengthInput, #roomWidthInput, #roomHeightInput'
	.keyup ->
		setTimeout ->
			updateRoomProperties()
		, 1000

$ '#roomSettings'
	.click (e)->
		e.preventDefault()
		$ '.popup'
			.removeClass 'active'
		$ '#roomSettingsPopup'
			.addClass 'active'


$ '[data-room-texture]'
	.click (e)->
		e.preventDefault()
		$(this).siblings().removeClass 'active'
		$(this).addClass 'active'
		room.setTexture $(this).data 'room-texture'




$ '#help'
	.click (e)->
		e.preventDefault()
		$ '.popup'
			.removeClass 'active'
		$ '#helpPopup'
			.addClass 'active'


$ '#scale'
	.click (e)->
		e.preventDefault()
		if !$(this).hasClass 'disabled'
			$(this).toggleClass 'active'
			if $(this).hasClass 'active'
				control.dispose()
				for c in control.children[0].children[0].children
					c.scale.set 0.0000001,0.0000001,0.0000001
				controls.enabled = off
				message 'Режим изменения размера'
				$ 'body'
					.bind 'mousewheel', (event, delta)->
						if control.object
							s =
								x: control.object.rect.x
								y: control.object.rect.y
								z: control.object.rect.z
							if delta > 0
								s.x += 0.01; s.y += 0.01; s.z += 0.01
							else
								s.x -= 0.01; s.y -= 0.01; s.z -= 0.01
							control.object.updateRect s
							collision control.object, OBJECTS
			else
				control.enpose()
				for c in control.children[0].children[0].children
					c.scale.set 1,1,1
				controls.enabled = on
				message 'Режим перемещения'