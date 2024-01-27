extends Node

@export var is_active: bool = false
@export var character_node: Node2D
@export var attack_damage: float = 10

var is_attacking: bool = false

var player_position: Vector2 = Vector2(10, 10)

@onready var sprite = get_parent().get_node("Sprite")
@onready var hitbox: Area2D = get_parent().get_node("HitBox")
@onready var hitbox_polygon = get_parent().get_node("HitboxPolygon")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.animation_looped.connect(attack_anim_ended)
	sprite.frame_changed.connect(on_frame_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_active:
		is_attacking = false
		return
	
	if is_attacking:
		return
	
	
func start_attack():
	is_attacking = true
	sprite.play("attack")

func attack_anim_ended():
	if not is_attacking:
		return
		
	is_attacking = false

func on_frame_changed():
	if sprite.animation != "attack":
		return
		
	if sprite.get_frame() == 8:
		for body in hitbox.get_overlapping_areas():
			hit_body(body)
	
	if sprite.get_frame() == 5:
		hitbox_polygon.visible = true

func hit_body(body):
	if body.get_parent().get_name() != "Player":
		return
	if body.get_name() == "HitBox":
		return
	var hpComp = body.get_parent().get_node_or_null("HealthComponent")
	if hpComp != null:
		hpComp.take_damage(attack_damage)
		body.get_parent().get_parent().increase_frenzy(12)
		
