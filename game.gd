extends Node2D


var frenzy_value: float = 0
@onready var frenzy_label = $FrenzyLabel
@export var frenzy_threshold = 50

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	decrease_frenzy(delta / 2)

func increase_frenzy(val: float):
	frenzy_value += val
	if frenzy_value > 100:
		frenzy_value = 100
	
	frenzy_label.text = str(ceil(frenzy_value))
	
	player.set_on_frenzy(frenzy_value > frenzy_threshold)
	
	

func decrease_frenzy(val: float):
	frenzy_value -= val
	if frenzy_value < 0:
		frenzy_value = 0
	
	frenzy_label.text = str(ceil(frenzy_value))
	
	player.set_on_frenzy(frenzy_value > frenzy_threshold)
