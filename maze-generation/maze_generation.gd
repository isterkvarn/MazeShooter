extends Node

const SOURCE_ID = 2
const FLOOR = Vector2i(3, 2)
const WALL = Vector2i(1, 1)

@onready var tile_map = $TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	# tile_map.set_cell(0, Vector2i(5, 5), SOURCE_ID, WALL)
	var graph = Graph.new(12, 15)
	graph.add_connection(Vector2i(0, 1), Vector2i(0, 0))
	draw_graph(graph)
	

func draw_graph(graph: Graph):
	for y in range(graph.height):
		for x in range(graph.width):
			draw_floor(Vector2i(x*2 + 1, y*2 + 1))

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

	for y in [0, graph.height*2]:
		for x in range(graph.width*2):
			draw_wall(Vector2i(x, y))

	for x in [0, graph.width*2]:
		for y in range(graph.height*2):
			draw_wall(Vector2i(x, y))

func draw_wall(pos: Vector2i):
	tile_map.set_cell(0, pos, SOURCE_ID, WALL)

func draw_floor(pos: Vector2i):
	tile_map.set_cell(0, pos, SOURCE_ID, FLOOR)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
