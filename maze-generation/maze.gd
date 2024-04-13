extends Node3D

@onready var floor = $Floor
@onready var walls = $Walls
@onready var roof = $Roof
@onready var debug = $Debug

const FLOOR_ITEM_ID = 0
const WALL_ITEM_ID = 0
const ROOF_ITEM_ID = 0

const DEBUG = false

@onready var generation = preload("maze_generation.gd").new()

func _ready():
	if DEBUG:
		debug.visible = true
		roof.visible = false
	create(25, 25)

func create(width: int, height):
	var graph = generation.generate(width, height)
	
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

func draw_floor(pos: Vector2i):
	floor.set_cell_item(Vector3i(pos.x, 0, pos.y), FLOOR_ITEM_ID)

func draw_wall(pos: Vector2i):
	walls.set_cell_item(Vector3i(pos.x, 1, pos.y), WALL_ITEM_ID)

func draw_roof(pos: Vector2i):
	roof.set_cell_item(Vector3i(pos.x, 2, pos.y), ROOF_ITEM_ID)

