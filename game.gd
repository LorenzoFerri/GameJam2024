extends Node2D


@export var frenzy_value: float = 70
@onready var frenzy_bar = $CanvasLayer/FrenzyBar
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
	
	frenzy_bar.value = ceil(frenzy_value)
	
	player.set_on_frenzy(frenzy_value > frenzy_threshold)

func decrease_frenzy(val: float):
	frenzy_value -= val
	if frenzy_value <= 0:
		pass
		#SceneManager.lose_cringe()
	
	if frenzy_value > frenzy_threshold:
		frenzy_value -= val
	
	frenzy_bar.value = ceil(frenzy_value)
	
	player.set_on_frenzy(frenzy_value > frenzy_threshold)

func win():
	if spawner_manager.is_finish():
		SceneManager.win()
