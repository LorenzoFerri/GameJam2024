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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	win()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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
	if spawner_manager.is_finish():
		SceneManager.win()
