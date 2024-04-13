extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var rotation_helper = $RotationHelper
@onready var muzzle = $RotationHelper/MuzzleFlash
@onready var animator = $RotationHelper/AnimationPlayer

const MAG_SIZE = 6
const MUZZLE_TIME = 0.2
const RELOAD_TIME = 3

var mag = MAG_SIZE
var reload_timer = 0
var muzzle_timer = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	$RotationHelper/SubViewportContainer/SubViewport/GunCam.global_transform = $RotationHelper/Camera3D.global_transform

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	handle_shoot(delta)
	
	if muzzle_timer > 0:
		muzzle_timer -= delta
	else:
		muzzle.visible = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _input(event):
	# Used for mouse movment
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		rotation_helper.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		rotation_helper.rotation.x = clampf(rotation_helper.rotation.x, -PI/2, PI/2)
		
func handle_shoot(delta):
	
	
	if reload_timer > 0:
		reload_timer -= delta
	
	# Handle shooting
	if Input.is_action_just_pressed("shoot") and reload_timer <= 0:
		muzzle.visible = true
		muzzle_timer = MUZZLE_TIME
		mag -= 1
	
	if Input.is_action_just_pressed("reload") or mag <= 0:
		reload_timer = RELOAD_TIME
		mag = MAG_SIZE
		animator.play("reload")
		
	# Handle muzzle flash timer
	if muzzle_timer > 0:
		muzzle_timer -= delta
	else:
		muzzle.visible = false
