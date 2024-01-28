extends Marker2D

var enemy_scene = preload("res://enemies/Infermiera.tscn")

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	enemy.set_global_position(global_position)
	
	get_parent().add_sibling(enemy)
	enemy.add_to_group("enemies")
	
	var player = get_parent().get_parent().get_node("/root/Game/Player")
	enemy.target = player
