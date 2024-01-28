extends Marker2D

@export var wave_max_number: int = 15
@export var displayable_enemies: int = 7
@export var spawn_timer_timeout: int = 5
var enemy_scene = preload("res://enemies/Infermiera.tscn")

@onready var spawn_timer: Timer = $InfermieraSpawnTimer

var wave_count: int = 0

func _ready():
	spawn_timer.wait_time = spawn_timer_timeout
	spawn_timer.start()

func _on_spawn_timer_timeout():
	if wave_count < wave_max_number && get_enemy_on_screen() < displayable_enemies:
		spawn_enemy()
		wave_count += 1
		
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	enemy.set_global_position(global_position)
	
	get_parent().add_sibling(enemy, true)
	enemy.add_to_group("enemies")
	
	var player = get_parent().get_parent().get_node("/root/Game/Player")
	print(player.global_position)
	enemy.target = player

func is_finish():
	return wave_max_number == wave_count

func get_enemy_on_screen():
	var enemies_on_screen = Array()
	
	for a in get_tree().get_nodes_in_group("enemies"):
		if a.name.contains("Infermiera"):
			enemies_on_screen.append(a)
	
	return enemies_on_screen.size()
