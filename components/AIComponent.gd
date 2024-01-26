extends Node

@export var is_active: bool = false
@export var attack_range: float = 10.0
@export var movement_speed: float = 500.0
@export var attack_speed: float = 1.0
@export var character_node: Node2D

var is_attacking: bool = false
var attack_windup: float = 0.0

var player_position: Vector2 = Vector2(10, 10)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_active:
		is_attacking = false
		return
	
	if is_attacking:
		return
	
	
	
