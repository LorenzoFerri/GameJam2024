extends CharacterBody2D


@export var movement_speed = 350.0
@export var attack_range = 500.0
@export var duration_seconds = 1.5
var direction: Vector2
var attack_damage: float = 10.0
var can_move: bool = true
@onready var sprite := $Sprite2D

@onready var hit_box := $Area2D

func _ready():
	velocity = direction * movement_speed
	if velocity.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		sprite.position.x -= 440
		$GoingDoggoSound.play()

		

func _physics_process(delta):
	duration_seconds -= delta
	
	if duration_seconds <= 0:
		can_move = false
		sprite.play("explosion")
	
	if not can_move:
		return
	
	sprite.play("walk")
	velocity = direction * movement_speed
	
	move_and_slide()


func hit_area(area):
	if area.get_name() == "HitBox":
		return
	var hpComp = area.get_parent().get_node_or_null("HealthComponent")
	if hpComp != null:
		hpComp.take_damage(attack_damage)
		area.get_parent().get_parent().increase_frenzy(6)
		$GoingDoggoSound.stop()
		$DogExplosion.play()
		queue_free()



func _on_sprite_2d_frame_changed():
	if sprite.animation == "explosion":
		sprite.scale += Vector2(0.1, 0.1)
		if sprite.frame == 3:
			for area in hit_box.get_overlapping_areas():
				hit_area(area)
			queue_free()
			$GoingDoggoSound.stop()
			$DogExplosion.play()


func _on_detonate_area_area_entered(area):
	if area.get_parent().get_name() == "Player":
		return
	if area.get_name() == "HitBox":
		return
	duration_seconds = 0


func _on_going_doggo_sound_finished():
	$GoingDoggoSound.play()
