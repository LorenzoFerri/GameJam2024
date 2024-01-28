extends Node2D

@onready var game_state = get_parent()
@onready var animated_sprite = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_state.frenzy_value == null:
		animated_sprite.play("idle")		
	if game_state.frenzy_value <= 20:
		animated_sprite.play("sleepy")
	elif 20 < game_state.frenzy_value and game_state.frenzy_value < 80:
		animated_sprite.play("laughing")
	else:
		animated_sprite.play("laughing_hard")
	pass
