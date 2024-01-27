extends Node2D


var frenzy_value: float = 50
@onready var frenzy_bar = $CanvasLayer/FrenzyBar
@export var frenzy_threshold = 80

@onready var player = $Player
@onready var enemy_spawn = $InfermieraSpawn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	win()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	decrease_frenzy(delta / 2)

func increase_frenzy(val: float):
	frenzy_value += val
	if frenzy_value > 100:
		frenzy_value = 100
	
	frenzy_bar.value = ceil(frenzy_value)
	
	player.set_on_frenzy(frenzy_value > frenzy_threshold)

func decrease_frenzy(val: float):
	frenzy_value -= val
	if frenzy_value <= 0:
		SceneManager.lose_cringe()
	
	frenzy_bar.value = ceil(frenzy_value)
	
	player.set_on_frenzy(frenzy_value > frenzy_threshold)

func win():
	if enemy_spawn.is_finish():
		SceneManager.win()
