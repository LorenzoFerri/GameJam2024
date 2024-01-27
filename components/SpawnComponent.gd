extends Node2D

var enemy
var corner

func _init():
	enemy = preload("res://enemies/Infermiera.tscn").instance()
	get_parent().add_child(enemy)
	corner = rotation_degrees
	
func _process(delta):
	var direction_x = 1 * cos(corner * PI / 200)
	var direction_y = 1 * sin(corner * PI / 200)
	
	var direction = Vector2(direction_x, direction_y)
	
	enemy.velocity = direction * enemy.movement_speed
	
	enemy.move_and_slide()
