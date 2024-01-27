extends Node2D

@export var path_length: int = 1

func _process(delta):
	var enemy = preload("res://enemies/Infermiera.tscn").instance()
	var direction_x = path_length * cos(rotation * PI / 200)
	var direction_y = path_length * sin(rotation * PI / 200)
	enemy.set_movement_target(Vector2(direction_x, direction_y))
	
	get_parent().add_child(enemy)
