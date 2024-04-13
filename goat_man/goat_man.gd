extends Node3D

const SPEED = 10
const CORRIDOR_SIZE = 5
var forward = Vector3.FORWARD
var turn_timer = 0

@onready var right_ray = $RayCastRight
@onready var left_ray  = $RayCastLeft
@onready var forward_ray = $RayCastForward
@onready var turn_left_ray = $RayCastForwardLeft
@onready var turn_right_ray = $RayCastForwardRight


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	turn_timer -= delta
	
	# Always run forward
	global_position += forward*SPEED*delta

	print((not left_ray.is_colliding()) and turn_left_ray.is_colliding())
	
	if (forward_ray.is_colliding() 
	or ((not left_ray.is_colliding()) and turn_left_ray.is_colliding()) 
	or ((not right_ray.is_colliding()) and turn_right_ray.is_colliding())) and turn_timer <= 0:
		
		turn_timer = 0.2
		
		# Adjust so in middle of corridor
		#global_position -= forward * (CORRIDOR_SIZE - forward_distance)
		
		var turn_options = []
		
		if not right_ray.is_colliding():
			turn_options.append(PI/2)
		
		if not left_ray.is_colliding():
			turn_options.append(-PI/2)
			
		var turn
		
		if turn_options:
			turn = turn_options.pick_random()
		else:
			turn = PI
			
		rotate_y(turn)
		forward = forward.rotated(Vector3(0, 1, 0), turn)
