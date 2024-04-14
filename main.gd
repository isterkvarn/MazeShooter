extends Node3D

const START_TIME = 5

@onready var player = %Player
@onready var goal = $Goal
@onready var goat_res = preload("res://goat_man/goat_man.tscn")
@onready var maze_res = preload("res://maze-generation/maze.tscn")

var maze_dimension = 4
var has_started = false
@onready var number_of_goats = get_goat_num()

var maze
var goats = []
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	new_level()

func new_level():
	maze = maze_res.instantiate()
	add_child(maze)
	maze.create(maze_dimension, maze_dimension)
	
	player.transform.origin = maze.get_spawn_coords()
	goal.transform.origin = maze.get_goal_coords()

func next_level():
	goats = []
	maze_dimension += 1
	timer = 0
	number_of_goats = get_goat_num()
	maze.queue_free()
	new_level()

func spawn_goats():
	for i in range(number_of_goats):
		spawn_goat()

func spawn_goat():
	var goat_pos = maze.get_random_pos()
	var goat = goat_res.instantiate()
	goat.transform.origin = maze.get_random_pos()
	goats.append(goat)
	maze.add_child(goat)

# How many goats per level
func get_goat_num():
	return (maze_dimension - 3) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_started:
		return

	if timer <= START_TIME:
		timer += delta
	else:
		has_started = true
		spawn_goats()
		timer = 0

func get_respawn_pos():
	var respawn = maze.get_random_pos()
	var player_pos = player.transform.origin
	var block_size = maze.get_block_size()
	while respawn.x/block_size == player_pos.x/block_size or respawn.z/block_size == player_pos.z/block_size:
		respawn = maze.get_random_pos()
	return respawn
	

func _on_goal_body_entered(body):
	next_level()
