extends Node2D

@export var path_length: int = 50
@export var wave_number: int = 5
@export var spawn_timer_timeout: int = 2
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
	
	var direction_x = enemy.global_position.x + path_length * cos(rotation)
	var direction_y = enemy.global_position.y + path_length * sin(rotation)
	var player = get_parent().get_node("/root/Game/Player")
	print(player.global_position)
	enemy.target = player
