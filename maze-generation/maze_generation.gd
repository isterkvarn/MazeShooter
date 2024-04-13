extends Node

func generate(width: int, height: int) -> Graph:
	var graph = Graph.new(width, height)
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

	return graph

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
