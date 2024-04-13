extends Area3D

const SPEED = 30
const CORRIDOR_SIZE = 5
const POS_MARGIN = 0.2
var forward = Vector3.FORWARD
var turn_timer = 0

@onready var right_ray = $RayCastRight
@onready var left_ray  = $RayCastLeft
@onready var forward_ray = $RayCastForward


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	turn_timer -= delta
	
	# Always run forward
	global_position += forward*SPEED*delta
	
	if forward_ray.is_colliding() or (in_grid() and turn_timer <= 0 and 
	(not left_ray.is_colliding() or not right_ray.is_colliding())):
		
		turn_timer = 0.2
		
		# Adjust so in middle of corridor
		global_position.x = snapped(global_position.x + 2.5, 5)
		global_position.y = snapped(global_position.y + 2.5, 5)
		
		var turn_options = []
		
		if not forward_ray.is_colliding():
			turn_options.append(0)
		
		if not right_ray.is_colliding():
			turn_options.append(PI/2)
		
		if not left_ray.is_colliding():
			turn_options.append(-PI/2)
			
		var turn = 0
		
		if turn_options:
			turn = turn_options.pick_random()
		else:
			turn = PI
			
		rotate_y(turn)
		forward = forward.rotated(Vector3(0, 1, 0), turn)
		
func in_grid():
	var global_pos = abs(global_position + Vector3(2.5, 0, 2.5))
	var decimal_x = global_pos.x - int(global_pos.x)
	var decimal_z = global_pos.z - int(global_pos.z)
	var mod_x = int(global_pos.x) % 5
	var mod_z = int(global_pos.z) % 5
	
	var within_x = (POS_MARGIN > (mod_x + decimal_x)) or (POS_MARGIN > (mod_x - decimal_x))
	var within_z = (POS_MARGIN > (mod_z + decimal_z)) or (POS_MARGIN > (mod_z - decimal_z))
	
	return within_x and within_z
	
func hit():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.dead()
