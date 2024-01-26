extends CharacterBody2D


@export var speed = 600.0
@export var damping = 0.6

@onready var dash_cooldown = $DashCooldown
var dash_speed = 0
@onready var dash_damping = 0.9
@onready var dash_particle = $GPUParticles2D


func _physics_process(delta):
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	var direction = Vector2(direction_x,direction_y).normalized()
	if direction.length():
		velocity = direction * speed + direction * dash_speed
	else:
		velocity *= damping
		
	dash_speed *= dash_damping
	
	if dash_speed <= 200:
		dash_particle.emitting = false
		
	if Input.is_action_just_pressed("dash"):
		dash()

	move_and_slide()
	

func dash():
	if dash_cooldown.is_stopped():
		dash_particle.emitting = true
		dash_cooldown.start()
		dash_speed = 2000


func _on_dash_cooldown_timeout():
	dash_cooldown.stop()
