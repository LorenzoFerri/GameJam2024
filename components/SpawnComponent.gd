extends Node2D

var enemy

func _init():
	# Spawna nemico
	# Muove nemico di due tile
	# Position property
	var enemy = preload("res://enemies/Infermiera.tscn").instance()
	get_parent().add_child(enemy)
	
func _process(delta):
	enemy.position.x += enemy.speed * delta
	enemy.position.y += enemy.speed * delta
