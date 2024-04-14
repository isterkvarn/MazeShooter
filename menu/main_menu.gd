extends Node3D

@onready var main = preload("res://main.tscn")
@onready var highscore = preload("res://highscore/highscore.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().root.add_child(main.instantiate())
	get_node("/root/MainMenu").queue_free()


func _on_highscore_button_pressed():
	get_tree().root.add_child(highscore.instantiate())
	get_node("/root/MainMenu").queue_free()
