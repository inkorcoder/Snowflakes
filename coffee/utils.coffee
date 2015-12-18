helpLine = null
helpBox = null
helpBoxes = []



# degrees / radians
deg = (radians)->
	radians * (180/Math.PI)
rad = (degrees)->
	degrees * (Math.PI/180)

rand = (min,max)->
	Math.random() * (max - min) + min


# create new line 
createLine = (vec1, vec2)->
	scene.remove helpLine
	material = new (THREE.LineBasicMaterial)(color: 0x00ffff)
	geometry = new (THREE.Geometry)
	geometry.vertices.push vec1
	geometry.vertices.push vec2
	helpLine = new (THREE.Line)(geometry, material)
	scene.add helpLine

# getting bbox from box
getBBox = (obj, color)->
	scene.remove( helpBox )
	helpBox = new THREE.BoundingBoxHelper( obj, (if color then color else 0xff0000) );
	helpBox.update()
	scene.add( helpBox )

# get bboxes fromn objects
getBBoxes = (arr)->
	for b in helpBoxes
		scene.remove b
	for b in arr
		bb = new THREE.BoundingBoxHelper( b, 0x00ff00 );
		bb.update()
		helpBoxes.push bb
		scene.add( bb )

# partical rect
getPrtialRect = (obj)->
	return {
		x: obj.rect.x/2
		y: obj.rect.y/2
		z: obj.rect.z/2
	}

# collisions
collision = (obj, objs)->
	# createBBox obj

	O = obj
	O.r = getPrtialRect obj
	O.p = obj.position

	C =
		p: control.position

	for b in helpBoxes
		scene.remove b
	helpBoxes = []
	collisions = []

	for o, i in objs
		if O.uuid isnt o.uuid
			o.r = getPrtialRect o
			o.p = o.position

			O.collisions.x = if (O.p.x - O.r.x < o.p.x + o.r.x) then on else off
			O.collisions.X = if (O.p.x + O.r.x > o.p.x - o.r.x) then on else off
			O.collisions.y = if (O.p.y - O.r.y < o.p.y + o.r.y) then on else off
			O.collisions.Y = if (O.p.y + O.r.y > o.p.y - o.r.y) then on else off
			O.collisions.z = if (O.p.z - O.r.z < o.p.z + o.r.z) then on else off
			O.collisions.Z = if (O.p.z + O.r.z > o.p.z - o.r.z) then on else off

			if (O.collisions.x and O.collisions.X) and (O.collisions.y and O.collisions.Y) and (O.collisions.z and O.collisions.Z)
				getBBox O
				collisions.push o

			# прилипание
			if (C.p.x - O.r.x < o.p.x + o.r.x + stickness and C.p.x > o.p.x and O.collisions.y and O.collisions.Y and O.collisions.z and O.collisions.Z)
				O.p.x = o.p.x+O.r.x+o.r.x
			if (C.p.x + O.r.x > o.p.x - o.r.x - stickness and C.p.x < o.p.x and O.collisions.y and O.collisions.Y and O.collisions.z and O.collisions.Z)
				O.p.x = o.p.x-O.r.x-o.r.x

			if (C.p.z - O.r.z < o.p.z + o.r.z + stickness and C.p.z > o.p.z and O.collisions.x and O.collisions.X and O.collisions.y and O.collisions.Y)
				O.p.z = o.p.z+O.r.z+o.r.z
			if (C.p.z + O.r.z > o.p.z - o.r.z - stickness and C.p.z < o.p.z and O.collisions.x and O.collisions.X and O.collisions.y and O.collisions.Y)
				O.p.z = o.p.z-O.r.z-o.r.z

			if (C.p.y - O.r.y < o.p.y + o.r.y + stickness and C.p.y > o.p.y and O.collisions.x and O.collisions.X and O.collisions.z and O.collisions.Z)
				O.p.y = o.p.y+O.r.y+o.r.y
			if (C.p.y + O.r.y > o.p.y - o.r.y - stickness and C.p.y < o.p.y and O.collisions.x and O.collisions.X and O.collisions.z and O.collisions.Z)
				O.p.y = o.p.y-O.r.y-o.r.y




			# console.log O.collisions.X, O.collisions.x

		if i is objs.length-1
			if collisions.length > 0
				getBBoxes collisions
			else
				scene.remove( helpBox )



getXY = (e)->
	mouse = getCoordinates e
	raycaster.setFromCamera mouse, camera
	intersects = raycaster.intersectObjects [room.plane]
	intersects[0].point


enableObjectControls = ->
	$('#editObject, #deleteObject, #rotation, #scale').removeClass 'disabled'

disableObjectControls = ->
	$('#editObject, #deleteObject, #rotation, #scale').addClass 'disabled'
	$('.popup').removeClass 'active'


message = (text)->
	elem = $ '<div/>'
			.addClass 'message'
			.html text
	$('.page-wrapper').append(elem)
	setTimeout ->
		elem.addClass 'active'
		setTimeout ->
			elem.removeClass 'active'
			setTimeout ->
				elem.remove()
			, 500
		, 4000
	, 100




setSliderScale = (val1, val2)->
	# console.log if val1 > val2 then 'biger' else 'smaller'
	if val1 > val2
		if window.currentZoom < ZOOM.max
			controls.zoomIn()
			controls.zoomIn()
	else
		if window.currentZoom > ZOOM.min
			controls.zoomOut()
			controls.zoomOut()
	# console.log window.currentZoom

setScale = (val)->
	console.log val


serialize = (mixed_val) -> # Generates a storable representation of a value
	# 
	# +   original by: Ates Goral (http://magnetiq.com)
	# +   adapted for IE: Ilia Kantor (http://javascript.ru)
	switch typeof (mixed_val)
		when "number"
			if isNaN(mixed_val) or not isFinite(mixed_val)
				return false
			else
				return ((if Math.floor(mixed_val) is mixed_val then "i" else "d")) + ":" + mixed_val + ";"
		when "string"
			return "s:" + mixed_val.length + ":\"" + mixed_val + "\";"
		when "boolean"
			return "b:" + ((if mixed_val then "1" else "0")) + ";"
		when "object"
			unless mixed_val?
				return "N;"
			else if mixed_val instanceof Array
				idxobj = idx: -1
				map = []
				i = 0

				while i < mixed_val.length
					idxobj.idx++
					ser = serialize(mixed_val[i])
					map.push serialize(idxobj.idx) + ser  if ser
					i++
				return "a:" + mixed_val.length + ":{" + map.join("") + "}"
			else
				class_name = get_class(mixed_val)
				return false  if class_name is `undefined`
				props = new Array()
				for prop of mixed_val
					ser = serialize(mixed_val[prop])
					props.push serialize(prop) + ser  if ser
				return "O:" + class_name.length + ":\"" + class_name + "\":" + props.length + ":{" + props.join("") + "}"
		when "undefined"
			return "N;"
	false