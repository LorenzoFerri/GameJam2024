extends Node

@onready var wave_timer = $WaveTimer
@onready var spawn_timer = $SpawnTimer
@onready var text_timer = $TextTimer
@onready var text = $CanvasLayer/TextureRect

@export var enemy_on_waves: Array[String]
@export var max_enemy_on_waves: Array[int]
@export var wave_time_out: int = 6
@export var spawn_time_out: int = 5

signal wave_paused(is_paused: bool)

var count_wave: int = 0
var count_wave_enemies: int = 0
var spawners: Array

func _ready():
	text.hide()
	wave_timer.wait_time = wave_time_out
	spawn_timer.wait_time = 1
	spawners = get_parent().get_tree().get_nodes_in_group("spawn")
	wave_timer.stop()
	spawn_timer.start()

func spawn_enemy():
	if get_enemies_on_screen() == max_enemy_on_waves[count_wave]:
		spawn_timer.wait_time = spawn_time_out
	if get_enemies_on_screen() < max_enemy_on_waves[count_wave] && count_wave_enemies < (enemy_on_waves[count_wave].length() / 2) + 1:
		var enemy_type = enemy_on_waves[count_wave].get_slice(",", count_wave_enemies)
		var spawner = randi_range(0, spawners.size()-1)
		count_wave_enemies += 1
		spawners[spawner].spawn(enemy_type)
	
func get_enemies_on_screen():
	var enemies_on_screen = get_parent().get_tree().get_nodes_in_group("enemies")
	if enemies_on_screen == null:
		return 0
	else:
		return enemies_on_screen.size()

func _on_spawn_timer_timeout():
	wave_paused.emit(false)
	spawn_enemy()

func next_wave():
	$NewWaveSound.play()
	text.show()
	spawn_timer.stop()
	wave_timer.stop()
	wave_timer.start()
	wave_paused.emit(true)
	text_timer.start()

func _on_wave_timer_timeout():
	wave_timer.stop()
	spawn_timer.wait_time = 1
	spawn_timer.start()
	$EndWaveSound.play()
	

func is_finish():
	if get_enemies_on_screen() == 0 && count_wave_enemies == (enemy_on_waves[count_wave].length() / 2) + 1:
		if (count_wave < enemy_on_waves.size() - 1):
			count_wave_enemies = 0
			count_wave += 1
			next_wave()
			return false
		else:
			return true
	else:
		return false

func _on_text_timer_timeout():
	text_timer.stop()
	text.hide()
