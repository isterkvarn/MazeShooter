extends Node

class_name Graph

var connections
var width
var height

func _init(width_in: int, height_in: int):
	width = width_in
	height = height_in
	_init_connections(width, height)

	print(connections)

func _init_connections(width, height):
	connections = []
	for y in range(height):
		connections.append([])
		for x in range(width):
			connections[y].append([])

func add_connection(node1: Vector2i, node2: Vector2i):
	connections[node1.y][node1.x].append(node2)
	connections[node2.y][node2.x].append(node1)

func get_connections(node: Vector2i):
	return connections[node.y][node.x]

func print_graph():
	print(connections)
