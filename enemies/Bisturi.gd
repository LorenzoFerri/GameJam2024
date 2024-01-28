extends CharacterBody2D


@export var movement_speed = 350.0
var destination: Vector2
var attack_damage: float

func _ready():
	$SpawnSound.play()

func _physics_process(delta):
	
	velocity = global_position.direction_to(destination) * movement_speed

	if abs(global_position.distance_to(destination)) <= 5:
		queue_free()
	
	look_at(destination)

	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.get_parent().get_name() != "Player":
		return
	if area.get_name() == "HitBox":
		return
	var hpComp = area.get_parent().get_node_or_null("HealthComponent")
	if hpComp != null:
		hpComp.take_damage(attack_damage)
		area.get_parent().get_parent().increase_frenzy(12)
		queue_free()
