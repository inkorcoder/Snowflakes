

			var camera, scene, renderer, control;

			init();
			render();

			function init() {

				renderer = new THREE.WebGLRenderer();
				renderer.setPixelRatio( window.devicePixelRatio );
				renderer.setSize( window.innerWidth, window.innerHeight );
				renderer.sortObjects = false;
				document.body.appendChild( renderer.domElement );

				//

				camera = new THREE.PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 3000 );
				camera.position.set( 1000, 500, 1000 );
				camera.lookAt( new THREE.Vector3( 0, 200, 0 ) );

				scene = new THREE.Scene();
				scene.add( new THREE.GridHelper( 500, 100 ) );

				var light = new THREE.DirectionalLight( 0xffffff, 2 );
				light.position.set( 1, 1, 1 );
				scene.add( light );


				var texture = THREE.ImageUtils.loadTexture( 'textures/crate.gif', THREE.UVMapping, render );
				texture.anisotropy = renderer.getMaxAnisotropy();

				var geometry = new THREE.BoxGeometry( 200, 200, 200 );
				var material = new THREE.MeshLambertMaterial( { map: texture } );

				control = new THREE.TransformControls( camera, renderer.domElement );
				control.addEventListener( 'change', render );

				var mesh = new THREE.Mesh( geometry, material );
				scene.add( mesh );

				control.attach( mesh );
				scene.add( control );

				window.addEventListener( 'resize', onWindowResize, false );

				window.addEventListener( 'keydown', function ( event ) {

					switch ( event.keyCode ) {

						case 81: // Q
							control.setSpace( control.space === "local" ? "world" : "local" );
							break;

						case 17: // Ctrl
							control.setTranslationSnap( 100 );
							control.setRotationSnap( THREE.Math.degToRad( 15 ) );
							break;

						case 87: // W
							control.setMode( "translate" );
							break;

						case 69: // E
							control.setMode( "rotate" );
							break;

						case 82: // R
							control.setMode( "scale" );
							break;

						case 187:
						case 107: // +, =, num+
							control.setSize( control.size + 0.1 );
							break;

						case 189:
						case 109: // -, _, num-
							control.setSize( Math.max( control.size - 0.1, 0.1 ) );
							break;

					}

				});

				window.addEventListener( 'keyup', function ( event ) {

					switch ( event.keyCode ) {

						case 17: // Ctrl
							control.setTranslationSnap( null );
							control.setRotationSnap( null );
							break;

					}

				});

			}

			function onWindowResize() {

				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();

				renderer.setSize( window.innerWidth, window.innerHeight );

				render();

			}

			function render() {

				control.update();

				renderer.render( scene, camera );

			}

		











/*
	Three.js "tutorials by example"
	Author: Lee Stemkoski
	Date: July 2013 (three.js v59dev)
*/

// MAIN

// standard global variables
var container, scene, camera, renderer, controls, stats;
var keyboard = new THREEx.KeyboardState();
var clock = new THREE.Clock();
// custom global variables

var MovingCube;
var collidableMeshList = [];

var arrowList = [];
var directionList = [];

init();
animate();

// FUNCTIONS 		
function init() 
{
	// SCENE
	scene = new THREE.Scene();
	// CAMERA
	var SCREEN_WIDTH = window.innerWidth, SCREEN_HEIGHT = window.innerHeight;
	var VIEW_ANGLE = 45, ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT, NEAR = 0.1, FAR = 20000;
	camera = new THREE.PerspectiveCamera( VIEW_ANGLE, ASPECT, NEAR, FAR);
	scene.add(camera);
	camera.position.set(0,150,400);
	camera.lookAt(scene.position);	
	// RENDERER
	if ( Detector.webgl )
		renderer = new THREE.WebGLRenderer( {antialias:true} );
	else
		renderer = new THREE.CanvasRenderer(); 
	renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
	container = document.getElementById( 'ThreeJS' );
	container.appendChild( renderer.domElement );
	// EVENTS
	THREEx.WindowResize(renderer, camera);
	THREEx.FullScreen.bindKey({ charCode : 'm'.charCodeAt(0) });
	// CONTROLS
	controls = new THREE.OrbitControls( camera, renderer.domElement );
	// STATS
	stats = new Stats();
	stats.domElement.style.position = 'absolute';
	stats.domElement.style.bottom = '0px';
	stats.domElement.style.zIndex = 100;
	container.appendChild( stats.domElement );
	// LIGHT
	var light = new THREE.PointLight(0xffffff);
	light.position.set(0,250,0);
	scene.add(light);
	// FLOOR
	var floorMaterial = new THREE.MeshBasicMaterial( {color:0x444444, side:THREE.DoubleSide} );
	var floorGeometry = new THREE.PlaneGeometry(1000, 1000, 10, 10);
	var floor = new THREE.Mesh(floorGeometry, floorMaterial);
	floor.position.y = -0.5;
	floor.rotation.x = Math.PI / 2;
	scene.add(floor);
	// SKYBOX/FOG
	var skyBoxGeometry = new THREE.CubeGeometry( 10000, 10000, 10000 );
	var skyBoxMaterial = new THREE.MeshBasicMaterial( { color: 0x9999ff, side: THREE.BackSide } );
	var skyBox = new THREE.Mesh( skyBoxGeometry, skyBoxMaterial );
	scene.add(skyBox);
	
	////////////
	// CUSTOM //
	////////////

	var cubeGeometry = new THREE.CubeGeometry(50,50,50,1,1,1);
	var wireMaterial = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe:true } );
	MovingCube = new THREE.Mesh( cubeGeometry, wireMaterial );
	MovingCube.position.set(0, 25.1, 0);
	scene.add( MovingCube );	
	
	var wallGeometry = new THREE.CubeGeometry( 100, 100, 20, 1, 1, 1 );
	var wallMaterial = new THREE.MeshBasicMaterial( {color: 0x8888ff} );
	var wireMaterial = new THREE.MeshBasicMaterial( { color: 0x000000, wireframe:true } );
	
	var wall = new THREE.Mesh(wallGeometry, wallMaterial);
	wall.position.set(100, 50, -100);
	scene.add(wall);
	collidableMeshList.push(wall);
	var wall = new THREE.Mesh(wallGeometry, wireMaterial);
	wall.position.set(100, 50, -100);
	scene.add(wall);
	
	var wall2 = new THREE.Mesh(wallGeometry, wallMaterial);
	wall2.position.set(-150, 50, 0);
	wall2.rotation.y = 3.14159 / 2;
	scene.add(wall2);
	collidableMeshList.push(wall2);
	var wall2 = new THREE.Mesh(wallGeometry, wireMaterial);
	wall2.position.set(-150, 50, 0);
	wall2.rotation.y = 3.14159 / 2;
	scene.add(wall2);
	
	
}

function clearText()
{   document.getElementById('message').innerHTML = '..........';   }

function appendText(txt)
{   document.getElementById('message').innerHTML += txt;   }

function animate() 
{
    requestAnimationFrame( animate );
	render();		
	update();
}

function update()
{
	var delta = clock.getDelta(); // seconds.
	var moveDistance = 200 * delta; // 200 pixels per second
	var rotateAngle = Math.PI / 2 * delta;   // pi/2 radians (90 degrees) per second
	
	if ( keyboard.pressed("A") )
		MovingCube.rotation.y += rotateAngle;
	if ( keyboard.pressed("D") )
		MovingCube.rotation.y -= rotateAngle;
			
	if ( keyboard.pressed("left") )
		MovingCube.position.x -= moveDistance;
	if ( keyboard.pressed("right") )
		MovingCube.position.x += moveDistance;
	if ( keyboard.pressed("up") )
		MovingCube.position.z -= moveDistance;
	if ( keyboard.pressed("down") )
		MovingCube.position.z += moveDistance;
				
	// collision detection:
	//   determines if any of the rays from the cube's origin to each vertex
	//		intersects any face of a mesh in the array of target meshes
	//   for increased collision accuracy, add more vertices to the cube;
	//		for example, new THREE.CubeGeometry( 64, 64, 64, 8, 8, 8, wireMaterial )
	//   HOWEVER: when the origin of the ray is within the target mesh, collisions do not occur
	var originPoint = MovingCube.position.clone();

	clearText();
	
	for (var vertexIndex = 0; vertexIndex < MovingCube.geometry.vertices.length; vertexIndex++)
	{		
		var localVertex = MovingCube.geometry.vertices[vertexIndex].clone();
		var globalVertex = localVertex.applyMatrix4( MovingCube.matrix );
		var directionVector = globalVertex.sub( MovingCube.position );
		
		var ray = new THREE.Raycaster( originPoint, directionVector.clone().normalize() );
		var collisionResults = ray.intersectObjects( collidableMeshList );
		if ( collisionResults.length > 0 && collisionResults[0].distance < directionVector.length() ) 
			appendText(" Hit ");
	}	

	controls.update();
	stats.update();
}

function render() 
{
	renderer.render( scene, camera );
}
