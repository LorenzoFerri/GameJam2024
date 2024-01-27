extends Node2D

@export var wave_number: int = 1
@export var spawn_timer_timeout: int = 5
var enemy_scene = preload("res://enemies/Infermiera.tscn")

@onready var spawn_timer: Timer = $SpawnTimer

var wave_count: int = 0

func _ready():
	spawn_timer.wait_time = spawn_timer_timeout

func _on_spawn_timer_timeout():
	if wave_count < wave_number:
		spawn_enemy()
		wave_count += 1
		
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	enemy.set_global_position(global_position)
	
	add_sibling(enemy)
	
	var player = get_parent().get_node("/root/Game/Player")
	print(player.global_position)
	enemy.target = player
