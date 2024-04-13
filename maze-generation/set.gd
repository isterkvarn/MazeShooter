extends Node

# Why the FUUUCK doesnt Godot have a built in set?!?!?!?!?!! angry emoji bonk bonk

class_name Set

var array

# Called when the node enters the scene tree for the first time.
func _init():
	array = []

func add(elem):
	for ar_elem in array:
		if elem == ar_elem:
			return
	array.append(elem)

func pop_random():
	return array.pop_at(randi() % array.size())

func remove(elem):
	array.erase(elem)

func size():
	return array.size()

func join(other: Set):
	for elem in other.array:
		if elem not in array:
			array.append(elem)

