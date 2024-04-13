extends Node3D

@onready var maze = $Maze
@onready var player = %Player
@onready var goat_res = preload("res://goat_man/goat_man.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	maze.create(2, 2)
	player.transform.origin = maze.get_spawn_coords()
	
	# Spawn a testing goat
	var goat_pos = maze.get_random_pos()
	var goat = goat_res.instantiate()
	goat.transform.origin = maze.get_random_pos()
	add_child(goat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
