extends Node3D

const START_TIME = 5
const MIN_SCORE = 25

@onready var player = %Player
@onready var goal = $Goal
@onready var goat_res = preload("res://goat_man/goat_man.tscn")
@onready var maze_res = preload("res://maze-generation/maze.tscn")
@onready var highscore = preload("res://highscore/highscore.tscn")

var maze_dimension = 4
var has_started = false
@onready var number_of_goats = get_goat_num()

var maze
var goats = []
var timer = 0
var level_score = 0
var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	new_level()
	player.set_level_score(level_score)

func new_level():
	maze = maze_res.instantiate()
	add_child(maze)
	maze.create(maze_dimension, maze_dimension)
	level_score = get_level_score()
	player.set_level_score(level_score)
	player.set_level(maze_dimension - 3)
	has_started = false

	player.transform.origin = maze.get_spawn_coords()
	goal.transform.origin = maze.get_goal_coords()

func next_level():
	goats = []
	maze_dimension += 1
	timer = 0
	player.add_score(level_score)
	
	has_started = false
	number_of_goats = get_goat_num()
	maze.queue_free()
	new_level()

func spawn_goats():
	for i in range(number_of_goats):
		spawn_goat()

func spawn_goat():
	var goat_pos = get_respawn_pos()
	var goat = goat_res.instantiate()
	goat.transform.origin = maze.get_random_pos()
	goats.append(goat)
	maze.add_child(goat)

# How many goats per level
func get_goat_num():
	return (maze_dimension - 3) 

func get_level_score():
	return 100 + (maze_dimension - 4) * 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# One second has passed
	if not int(elapsed_time) == int(elapsed_time + delta):
		if level_score > MIN_SCORE:
			level_score -= 1
			player.set_level_score(level_score)

	elapsed_time += delta
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
	var respawn_distance = block_size * 5
	var count = 0; # if there is not point
	while (respawn.distance_to(Vector3(player_pos.x, 0, player_pos.z)) < respawn_distance
		or count > 1000):
		respawn = maze.get_random_pos()
		count += 1
	return respawn
	

func _on_goal_body_entered(body):
	next_level()
