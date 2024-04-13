extends Node

const SOURCE_ID = 2
const FLOOR = Vector2i(3, 2)
const WALL = Vector2i(1, 1)

@onready var tile_map = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()

func generate():
	var graph = Graph.new(30, 30)
	var edges = _generate_possible_edges(graph)
	var disjoint_sets = _generate_disjoint_sets(graph)

	while edges.size() > 0:
		var edge = edges.pop_random()
		var join_sets = _join_disjoint_sets(disjoint_sets, edge[0], edge[1])
		
		if not join_sets.is_empty():
			# Join the sets
			join_sets[0].join(join_sets[1])
			disjoint_sets.erase(join_sets[1])
			# Add the connection to the graph
			graph.add_connection(edge[0], edge[1])

	draw_graph(graph)

func _generate_possible_edges(graph):
	var edges = Set.new()
	
	# Set of nodes that are reachable from each other
	var disjoint_sets = _generate_disjoint_sets(graph)
	
	for y in range(graph.height):
		for x in range(graph.width):
			if x+1 < graph.width:
				edges.add([Vector2i(x, y), Vector2i(x+1, y)])
			if y+1 < graph.height:
				edges.add([Vector2i(x, y), Vector2i(x, y+1)])
	return edges

func _generate_disjoint_sets(graph):
	var disjoint_sets = []
	
	for y in range(graph.height):
		for x in range(graph.width):
			var new_set = Set.new()
			new_set.add(Vector2i(x, y))
			disjoint_sets.append(new_set)
	
	return disjoint_sets

# If an edge would connect the two disjoint sets, return the sets
func _join_disjoint_sets(disjoint_sets, node1: Vector2i, node2: Vector2i):
	var node1_set = null
	var node2_set = null
	
	for dis_set in disjoint_sets:
		if node1 in dis_set.array:
			node1_set = dis_set
		if node2 in dis_set.array:
			node2_set = dis_set
	
	if node1_set == null or node2_set == null:
		return []
	if node1_set == node2_set:
		return []

	return [node1_set, node2_set]

func draw_graph(graph: Graph):
	for y in range(graph.height):
		for x in range(graph.width):
			draw_floor(Vector2i(x*2 + 1, y*2 + 1))
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

	for y in [0, graph.height*2]:
		for x in range(graph.width*2):
			draw_wall(Vector2i(x, y))

	for x in [0, graph.width*2]:
		for y in range(graph.height*2):
			draw_wall(Vector2i(x, y))
	
	for y in range(graph.height):
		for x in range(graph.width):
			pass

func draw_wall(pos: Vector2i):
	tile_map.set_cell(0, pos, SOURCE_ID, WALL)

func draw_floor(pos: Vector2i):
	tile_map.set_cell(0, pos, SOURCE_ID, FLOOR)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
