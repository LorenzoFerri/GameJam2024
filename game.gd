extends Node2D


var high_frenzy = preload("res://assets/ui/fun_bar/Gialla.png")
var normal_frenzy = preload("res://assets/ui/fun_bar/Blu.png")
var low_frenzy = preload("res://assets/ui/fun_bar/Grigio.png")
var bimbo_sbellico = preload("res://assets/ui/fun_bar/Bambino HAPPY.png")
var bimbo_ride = preload("res://assets/ui/fun_bar/Bambino happy(1).png")
var bimbo_noia = preload("res://assets/ui/fun_bar/Bambino noia.png")

@export var frenzy_value: float = 70
@onready var frenzy_bar = $CanvasLayer/FrenzyBar
@onready var faccia_bimbo = $CanvasLayer/FacciaBimbo
@export var frenzy_threshold = 80

@onready var player = $Player
@onready var spawner_manager = $SpawnerManager
@onready var pause_screen = $CanvasLayer/PauseScreen

var wave_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = SceneManager.current_player_pos
	$Soundtrack.play()
	
func _process(delta):
	if spawner_manager.is_finish():
		win()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !wave_paused:
		decrease_frenzy(delta * 4)

func increase_frenzy(val: float):
	frenzy_value += val
	if frenzy_value > 100:
		frenzy_value = 100
	
	if frenzy_value >= 80:
		frenzy_bar.texture_progress = high_frenzy
		faccia_bimbo.texture = bimbo_sbellico
	elif frenzy_value >= 20:
		frenzy_bar.texture_progress = normal_frenzy
		faccia_bimbo.texture = bimbo_ride
	
	frenzy_bar.value = ceil(frenzy_value)
	
	if frenzy_value > frenzy_threshold:
		$FrenzySound.play()
	
	player.set_on_frenzy(frenzy_value > frenzy_threshold)

func decrease_frenzy(val: float):
	frenzy_value -= val
	if frenzy_value <= 0:
		SceneManager.lose_cringe()
	
	if frenzy_value > frenzy_threshold:
		frenzy_value -= val
		
	if frenzy_value < 20:
		frenzy_bar.texture_progress = low_frenzy
		faccia_bimbo.texture = bimbo_noia
		
	elif frenzy_value < 80:
		frenzy_bar.texture_progress = normal_frenzy
		faccia_bimbo.texture = bimbo_ride
		
	
	frenzy_bar.value = ceil(frenzy_value)
	
	player.set_on_frenzy(frenzy_value > frenzy_threshold)

func win():
	SceneManager.win()


func _on_spawner_manager_wave_paused(is_paused: bool):
	if is_paused:
		wave_paused = true
		player.heal()
	else:
		wave_paused = false
		player.stop_heal()


func _on_soundtrack_finished():
	$Soundtrack.play()
