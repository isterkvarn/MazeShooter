extends Node3D

@onready var player = %Player
@onready var goal = $Goal
@onready var goat_res = preload("res://goat_man/goat_man.tscn")
@onready var maze_res = preload("res://maze-generation/maze.tscn")

var maze_dimension = 4
@onready var number_of_goats = get_goat_num()

var maze
var goats = []

# Called when the node enters the scene tree for the first time.
func _ready():
	new_level()
	for i in range(6):
		maze_dimension += 1

func new_level():
	maze = maze_res.instantiate()
	add_child(maze)
	maze.create(maze_dimension, maze_dimension)
	
	player.transform.origin = maze.get_spawn_coords()
	goal.transform.origin = maze.get_goal_coords()

	spawn_goats()

func next_level():
	goats = []
	maze_dimension += 1
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
	pass

func _on_goal_body_entered(body):
	next_level()
