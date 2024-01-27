extends Node2D

@onready var player = $Player
@onready var hurt_nurse = $HurtInfermiera

# Called when the node enters the scene tree for the first time.
func _ready():
	hurt_nurse.health_component.maxHp = 10
	hurt_nurse.health_component.hp = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	check_killed_hurt_nurse()

func check_killed_hurt_nurse():
	if hurt_nurse == null:
		SceneManager.goto_scene("res://game.tscn")

func increase_frenzy(_ignored):
	"""Player tries to increase frenzy but here it doesn't exist"""
	pass

