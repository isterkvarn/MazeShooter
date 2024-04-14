extends Node3D

@onready var floor = $Floor
@onready var walls = $Walls
@onready var roof = $Roof
@onready var debug = $Debug

const FLOOR_ITEM_ID = 0
const WALL_ITEM_ID = 1
const ROOF_ITEM_ID = 1

const FALL_HEIGHT = 5

const DEBUG = false

var graph = null
var goal

@onready var generation = preload("maze_generation.gd").new()

func _ready():
	if DEBUG:
		debug.visible = true
		roof.visible = false
		create(9, 9)

func get_block_size():
	return floor.cell_size.x

func get_spawn_coords():
	# Assume blocks are uniform and all grids have the same size
	var maze = maze_to_map(Vector2i(graph.width/2, graph.height/2))
	return Vector3(maze.x, floor.cell_size.x * FALL_HEIGHT + 1, maze.y)

func get_goal_coords():
	var goal_pos = maze_to_map(goal)
	return Vector3(
		goal_pos.x,
		-FALL_HEIGHT * floor.cell_size.x,
		goal_pos.y
	)

func get_random_pos():
	var pos = Vector2i(randi() % graph.width, randi() % graph.height)
	pos = maze_to_map(pos)
	return Vector3(pos.x, floor.cell_size.x, pos.y)

func maze_to_map(coord: Vector2i) -> Vector2:
	var cell_size = floor.cell_size.x
	var grid_cell = Vector2i(coord.x*2 + 1, coord.y*2 + 1)

	return Vector2(
		grid_cell.x * cell_size + cell_size / 2,
		grid_cell.y * cell_size + cell_size / 2,
	)

func create(width: int, height):
	graph = generation.generate(width, height)
	
	# Draw the outer walls
	for y in [0, graph.height*2]:
		for x in range(graph.width*2):
			draw_wall(Vector2i(x, y))
	for x in [0, graph.width*2]:
		for y in range(graph.height*2):
			draw_wall(Vector2i(x, y))
	
	# Draw the floor and roof planes
	for y in range(graph.height * 2 + 1):
		for x in range(graph.width * 2 + 1):
			draw_floor(Vector2i(x, y))
			draw_roof(Vector2i(x, y))
	
	# Draw the internal walls
	for y in range(graph.height):
		for x in range(graph.width):
			draw_wall(Vector2i(x*2 + 2, y*2 + 2))

			for rel_pos in [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]:
				var adj_node: Vector2i = Vector2i(x, y) + rel_pos

				# check for bounds oops
				if adj_node.x < 0 or adj_node.y < 0:
					continue
				if adj_node.x >= graph.width or adj_node.y >= graph.height:
					continue
				
				if adj_node in graph.get_connections(Vector2i(x, y)):
					draw_floor(Vector2i(x*2 + 1 + rel_pos.x, y*2 + 1 + rel_pos.y))
				else:
					draw_wall(Vector2i(x*2 + 1 + rel_pos.x, y*2 + 1 + rel_pos.y))
	create_spawn()
	create_goal()

func create_spawn():
	var spawn = Vector2i((graph.width/2)*2 + 1, (graph.height/2) * 2 + 1)
	remove_roof(spawn)
	
	for pos in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		for y in range(2, 2 + FALL_HEIGHT):
			draw_wall(spawn + pos, y)

func create_goal():
	var dead_ends = []
	
	for y in range(graph.height):
		for x in range(graph.width):
			if graph.get_connections(Vector2i(x, y)).size() == 1:
				dead_ends.append(Vector2i(x, y))

	# No idea how it could happen, but better safe than sorry
	if not dead_ends.is_empty():
		goal = dead_ends[randi() % dead_ends.size()]
	else:
		goal = Vector2i(randi() % graph.width, randi() % graph.height)

	var grid_cell = Vector2i(goal.x*2 + 1, goal.y*2 + 1)
	
	# Remove the floor
	remove_floor(Vector2i(grid_cell.x, grid_cell.y))

	for pos in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		for y in range(-FALL_HEIGHT, 0):
			draw_wall(grid_cell + pos, y)

func draw_floor(pos: Vector2i):
	floor.set_cell_item(Vector3i(pos.x, 0, pos.y), FLOOR_ITEM_ID)

func draw_wall(pos: Vector2i, y=1):
	walls.set_cell_item(Vector3i(pos.x, y, pos.y), WALL_ITEM_ID)

func draw_roof(pos: Vector2i):
	roof.set_cell_item(Vector3i(pos.x, 2, pos.y), ROOF_ITEM_ID)

func remove_floor(pos: Vector2i):
	floor.set_cell_item(Vector3i(pos.x, 0, pos.y), -1)

func remove_wall(pos: Vector2i):
	walls.set_cell_item(Vector3i(pos.x, 1, pos.y), -1)

func remove_roof(pos: Vector2i):
	roof.set_cell_item(Vector3i(pos.x, 2, pos.y), -1)
