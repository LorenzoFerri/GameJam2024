extends CharacterBody2D


@export var movement_speed = 350.0
@export var attack_range = 500.0
@export var duration_seconds = 1.5
var direction: Vector2
var attack_damage: float = 10.0
var can_move: bool = true

func _ready():
	velocity = direction * movement_speed
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
		global_position.x -= 256
		

func _physics_process(delta):
	duration_seconds -= delta
	
	if duration_seconds <= 0:
		can_move = false
		$Sprite2D.play("explosion")
	
	if not can_move:
		return
	
	$Sprite2D.play("walk")
	velocity = direction * movement_speed

	move_and_slide()


func hit_area(area):
	if area.get_name() == "HitBox":
		return
	var hpComp = area.get_parent().get_node_or_null("HealthComponent")
	if hpComp != null:
		hpComp.take_damage(attack_damage)
		area.get_parent().get_parent().increase_frenzy(6)
		queue_free()



func _on_sprite_2d_frame_changed():
	if $Sprite2D.animation == "explosion":
		$Sprite2D.scale += Vector2(0.1, 0.1)
		if $Sprite2D.frame == 3:
			for area in $Area2D.get_overlapping_areas():
				hit_area(area)
			queue_free()


func _on_detonate_area_area_entered(area):
	if area.get_parent().get_name() == "Player":
		return
	if area.get_name() == "HitBox":
		return
	duration_seconds = 0
