extends Node3D

@onready var maze = $Maze
@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	maze.create(4, 4)
	var spawn_pos = maze.get_spawn_coords()
	player.transform.origin = Vector3(spawn_pos.x, 6, spawn_pos.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
