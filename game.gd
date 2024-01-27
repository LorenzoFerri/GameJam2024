extends Node2D

var spawned_enemy = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func _add_spawned_enemy(enemy):
	spawned_enemy.append(enemy)
	enemy.set_movement_target($Player.global_position)
