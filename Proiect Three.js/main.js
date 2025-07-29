import * as THREE from 'three';
import WebGL from 'three/addons/capabilities/WebGL.js';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
if (WebGL.isWebGLAvailable()) {

    //scena, camera, lumina
    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0x3c6382);
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth /
        window.innerHeight, 0.1, 1000);
    camera.position.set(0, 0, 100);
    camera.lookAt(0, 0, 0);

    const ambientLight = new THREE.AmbientLight(0xdddddd, 0.7);
    scene.add(ambientLight);

    const directionalLight = new THREE.DirectionalLight(0xffffff, 2);
    directionalLight.position.set(40,100,40);
    scene.add(directionalLight);
    directionalLight.castShadow = true
    directionalLight.shadow.mapSize.width = 1024
    directionalLight.shadow.mapSize.height = 1024
    directionalLight.shadow.camera.near = 0.1
    directionalLight.shadow.camera.far = 30

    scene.add(new THREE.AxesHelper(100));

    scene.fog = new THREE.Fog(0xcccccc, 0.1, 1000);

    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.shadowMap.enabled = true;
    document.body.appendChild(renderer.domElement);

    //orbit control
    let controls = new OrbitControls(camera, renderer.domElement);

    //pendul
    const pendulumBallGeometry = new THREE.SphereGeometry(15, 32, 32);
    const pendulumBallMaterial = new THREE.MeshPhongMaterial({
        color: 0xefc5fa,
        reflectivity: 0.7,
        shininess: 45,
        specular: 0x9cdbc0
    });

    const pendulumBallMesh = new THREE.Mesh(pendulumBallGeometry,
        pendulumBallMaterial);
    pendulumBallMesh.position.z = -100;
    pendulumBallMesh.position.y = -6;
    pendulumBallMesh.castShadow = true;
    pendulumBallMesh.receiveShadow = true;

    const pendulumStringGeometry = new THREE.CylinderGeometry(0.3, 0.3,200,32);
    const pendulumStringMaterial = new THREE.MeshPhongMaterial({
        color: 0x61485b,
        reflectivity: 0.3,
        shininess: 35,
        specular: 0xf6f7ad
    });
    const pendulumStringMesh = new THREE.Mesh(pendulumStringGeometry,
        pendulumStringMaterial);
    pendulumStringMesh.position.y = 100;
    pendulumStringMesh.position.z = -100;
    pendulumStringMesh.castShadow = true;
    pendulumStringMesh.receiveShadow = true;

    const pendulumGroup = new THREE.Group();
    scene.add(pendulumGroup); 

    pendulumGroup.add(pendulumBallMesh);
    pendulumGroup.add(pendulumStringMesh);
    pendulumGroup.castShadow = true;
    pendulumGroup.receiveShadow = true;
    pendulumGroup.position.y = 0;

    //bounding box pendul
    let pendulumBoundingBoxesArray = [];
    pendulumGroup.children.forEach((child) => {
        let pendulumBoundingBox = new THREE.Box3(new THREE.Vector3(),
            new THREE.Vector3());
        pendulumBoundingBox.setFromObject(child);
        pendulumBoundingBoxesArray.push(pendulumBoundingBox);
    });
    

    let pointOfRotation = new THREE.Vector3(0, 200, -100);
    let axisOfRotation = new THREE.Vector3(0, 0, 1);
    let theta = Math.PI / 200;
    let angle = (3 * Math.PI) / 2;

    //miscare pendul
    function updatePendulum() {
        if (angle >= (11 * Math.PI) / 6) {
            theta = -Math.PI / 200;
        }
        else if (angle <= (7 * Math.PI) / 6) {
            theta = Math.PI / 200;
        }

        angle += theta;
        pendulumGroup.position.sub(pointOfRotation); 
        pendulumGroup.position.applyAxisAngle(axisOfRotation, theta);
        pendulumGroup.position.add(pointOfRotation); 
        pendulumGroup.rotateOnAxis(axisOfRotation, theta);
    }

    //tub
    class CustomCosCurve extends THREE.Curve {

        constructor(scale = 1) {
            super();
            this.scale = scale;
        }

        getPoint(t, optionalTarget = new THREE.Vector3()) {

            const tx = t * 3 - 1.5+1.2;
            const ty = Math.cos(3 * Math.PI/2 * t)+0.75;
            const tz = -3.75;

            return optionalTarget.set(tx, ty, tz).multiplyScalar(this.scale);
        }
    }

    const path = new CustomCosCurve(80);
    const tubeGeometry = new THREE.TubeGeometry(path, 20, 10, 30, false);
    const tubeMaterial = new THREE.MeshLambertMaterial (
        {
            color: 0x36d1ad,
            reflectivity: 0.4,
        });
    const tube = new THREE.Mesh(tubeGeometry, tubeMaterial);
    scene.add(tube);
    tube.receiveShadow = true;
    tube.castShadow = true;

    //bounding box tub
    let tubeBoundingBox = new THREE.Box3(new THREE.Vector3(), new THREE.Vector3());
    tubeBoundingBox.setFromObject(tube);

    //particule
    let particles;
    let positions = [];
    let velocities = [];

    const numOfParticles = 15000;
    const maxRange = 1000, minRange = maxRange / 2;
    const minHeight = 150;

    const particleTextureLoader = new THREE.TextureLoader();
    const particleGeometry = new THREE.BufferGeometry();
    addParticles();

    function addParticles() {
        for (let i = 0; i < numOfParticles; i++) {
            positions.push(
                Math.floor(Math.random() * maxRange - minRange),
                Math.floor(Math.random() * minRange + minHeight),
                Math.floor(Math.random()*maxRange-minRange)
            );

            velocities.push(
                Math.floor(Math.random() * 6 - 3) * 0.1,
                Math.floor(Math.random() * 5 + 0.12) * 0.18,
                Math.floor(Math.random() * 6 - 3) * 0.1
            );
        }

        particleGeometry.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
        particleGeometry.setAttribute('velocity', new THREE.Float32BufferAttribute(velocities, 3));

        const particleMaterial = new THREE.PointsMaterial(
            {
                size: 4,
                map: particleTextureLoader.load("Sprites/snowflake.png"),
                blending: THREE.AdditiveBlending,
                depthTest: false,
                transparent: true,
                opacity:0.7
            }
        );

        particles = new THREE.Points(particleGeometry, particleMaterial);
        scene.add(particles);
    }

    //miscarea particulelor
    function updateParticles() {
        for (let i = 0; i < numOfParticles * 3; i+=3) {
            particles.geometry.attributes.position.array[i] -=
                particles.geometry.attributes.velocity.array[i];
            particles.geometry.attributes.position.array[i + 1] -=
                particles.geometry.attributes.velocity.array[i + 1];
            particles.geometry.attributes.position.array[i + 2] -=
                particles.geometry.attributes.velocity.array[i + 2];

            if (particles.geometry.attributes.position.array[i + 1] < -30) {
                particles.geometry.attributes.position.array[i] =
                    Math.floor(Math.random() * maxRange - minRange);
                particles.geometry.attributes.position.array[i + 1] =
                    Math.floor(Math.random() * minRange + minHeight);
                particles.geometry.attributes.position.array[i + 2] =
                    Math.floor(Math.random() * maxRange - minRange);
            }
        }
        particles.geometry.attributes.position.needsUpdate = true;
    }

    //teren
    function createGround() {
        const groundGeometry = new THREE.PlaneGeometry(1000, 1000, 100, 100);
        let heightMap = new THREE.TextureLoader()
            .load("/Terrain/heightmap6.jpg");
        
        let snowColor = new THREE.TextureLoader()
            .load("/Terrain/SnowColor2.jpg");

        heightMap.wrapS = heightMap.wrapT = THREE.RepeatWrapping;
        heightMap.repeat.set(1, 1);

        const groundMeshMaterial = new THREE.MeshStandardMaterial({
            color: 0xFFFAFA,
            displacementMap: heightMap,
            displacementScale: 15,
            map:snowColor,
            roughness: 1,
        });

        const groundMesh = new THREE.Mesh(groundGeometry, groundMeshMaterial);
        scene.add(groundMesh);
        groundMesh.receiveShadow = true;
        groundMesh.rotation.x = -Math.PI / 2;
        groundMesh.position.y = -34;
        groundMesh.position.z = -400;
    }

    createGround();

    //masina
    const loader = new GLTFLoader();
    let car;

    //bounding box car
    let carBoundingBoxesArray = [];

    loader.load('./Models/2022__mercedes-amg_one_forza_editon.glb', function (gltf) {
        car = gltf.scene;
        car.scale.set(20, 20, 20);
        car.translateY(-30);
        car.castShadow = true;
        car.receiveShadow = true;

        car.traverse(child => {
            if (child.isMesh) {
                let carBoundingBox = new THREE.Box3(new THREE.Vector3(), new THREE.Vector3());
                carBoundingBox.setFromObject(child);
                carBoundingBoxesArray.push(carBoundingBox);
            }
        });
        scene.add(car);
    }, function () {
        console.log('se incarca modelul 3D');
    },
        function (error) {

        console.error(error.getWebGLErrorMessage);

        });

    function animation1() {
        tube.material.transparent = true;
        tube.material.opacity = 0.5;
        tube.material.color = new THREE.Color(Math.random() * 0xffffff);
    }

    function animation2() {
        pendulumGroup.children.forEach(child => {
            child.material.transparent = true;
            child.material.opacity = 0.5;
            child.material.color = new THREE.Color(Math.random() * 0xffffff);
        });
    }

    function checkCollisions() {
        for (let i = 0; i < carBoundingBoxesArray.length; i++) {
            if (carBoundingBoxesArray[i].intersectsBox(tubeBoundingBox)) {
                animation1();
            } else {
                tube.material.opacity = 1;
            }

            for (let j = 0; j < pendulumBoundingBoxesArray.length; j++) {
                if (carBoundingBoxesArray[i]
                    .intersectsBox(pendulumBoundingBoxesArray[j])) {
                    animation2();
                } else {
                    pendulumGroup.children.forEach(child => {
                        child.material.opacity = 1;
                    });
                }
            }
            
        }
        
    }
    function animate(time) {
        updateParticles();
        updatePendulum();

        
        if (car !== undefined) {

            let j = 0;
            pendulumGroup.children.forEach((child) => {
                pendulumBoundingBoxesArray[j].copy(child.geometry.boundingBox)
                    .applyMatrix4(child.matrixWorld);
                j++;
            });
            let i = 0;
            car.traverse(child => {
                if (child.isMesh) {
                    carBoundingBoxesArray[i].copy(child.geometry.boundingBox)
                        .applyMatrix4(child.matrixWorld);
                    i++;
                }
            });
            
            camera.lookAt(car.position);
        }

        checkCollisions();

        renderer.render(scene, camera);
        controls.update();
    }
    renderer.setAnimationLoop(animate);

    //control masina
    var xSpeed = 0.05;
    var zSpeed = 5;

    document.addEventListener("keydown", onDocumentKeyDown, false);
    function onDocumentKeyDown(event) {
        var keyCode = event.which;
        if (keyCode == 40) {
            car.translateZ(zSpeed);
        } else if (keyCode == 38) {
            car.translateZ(-zSpeed);
        } else if (keyCode == 37) {
            car.rotateY(xSpeed);
        } else if (keyCode == 39) {
            car.rotateY(-xSpeed);
        }
        car.position.needsUpdate = true;
        camera.needsUpdate = true;
    };
    function onWindowResize() {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    }
    window.addEventListener("resize", onWindowResize);

} else {

    const warning = WebGL.getWebGLErrorMessage();
    document.getElementById('container').appendChild(warning);

}

