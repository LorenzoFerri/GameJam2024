extends Node

var bisturi_scene = preload("res://enemies/Bisturi.tscn")

@export var is_active: bool = false
@export var character_node: Node2D
@export var attack_damage: float = 10

@export var is_ranged: bool = false

var is_attacking: bool = false

@onready var sprite = get_parent().get_node("Sprite")
@onready var hitbox: Area2D = get_parent().get_node("HitBox")
@onready var hitbox_polygon = get_parent().get_node("HitboxPolygon")

var saved_bisturi_destination = Vector2(0, 0)

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
	get_parent().get_node("AttackSound").play()

func attack_anim_ended():
	if not is_attacking:
		return
		
	is_attacking = false

func on_frame_changed():
	if sprite.animation != "attack":
		return
		
	if not is_ranged:
		if sprite.get_frame() == 8:
			for body in hitbox.get_overlapping_areas():
				hit_body(body)
		
		if sprite.get_frame() == 5:
			pass
			#hitbox_polygon.visible = true
	else:
		if sprite.get_frame() == 3:
			saved_bisturi_destination = get_parent().target.global_position
		if sprite.get_frame() == 5:
			var bisturi = bisturi_scene.instantiate()
			bisturi.attack_damage = attack_damage
			bisturi.global_position = get_parent().global_position
			bisturi.global_position.y -= 200
			bisturi.destination = saved_bisturi_destination
			get_parent().add_sibling(bisturi)

func hit_body(body):
	if body.get_parent().get_name() != "Player":
		return
	if body.get_name() == "HitBox":
		return
	var hpComp = body.get_parent().get_node_or_null("HealthComponent")
	if hpComp != null:
		hpComp.take_damage(attack_damage)
		body.get_parent().get_parent().increase_frenzy(12)
		$PlayerTakesDamage.play()
	
		
