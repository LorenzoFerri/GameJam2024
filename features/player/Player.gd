extends CharacterBody2D


@export var speed = 600.0
@export var damping = 0.6

@onready var dash_cooldown := $DashCooldown
var dash_speed = 0
@onready var dash_damping = 0.9
@onready var dash_particle := $GPUParticles2D
@onready var animated_sprite := $AnimatedSprite2D
@onready var hurt_box := $HurtBox
@onready var smear := $HurtBox/Smear
var direction = Vector2.ZERO

func _physics_process(delta):
	if animated_sprite.animation != "attack":
		var direction_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var direction_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		direction = Vector2(direction_x,direction_y).normalized()
	if direction.length():
		velocity = direction * speed + direction * dash_speed
	else:
		velocity *= damping
	
	hurt_box.rotation = direction.angle()
		
	if direction.x > 0:
		animated_sprite.scale.x = 0.5
		dash_particle.scale.x = 0.5
	elif direction.x < 0:
		animated_sprite.scale.x = -0.5
		dash_particle.scale.x = -0.5
		
	var frame_index: int = animated_sprite.get_frame()
	var animation_name: String = animated_sprite.animation
	var sprite_frames: SpriteFrames = animated_sprite.get_sprite_frames()
	var current_texture: Texture2D = sprite_frames.get_frame_texture(animation_name, frame_index)
	dash_particle.texture = current_texture
		
	dash_speed *= dash_damping
	
	if dash_speed <= 200:
		dash_particle.emitting = false
		
	if Input.is_action_just_pressed("dash"):
		dash()
		
	if Input.is_action_just_pressed("attack") and animated_sprite.animation != "attack":
		attack()
	move_and_slide()

	

func dash():
	if dash_cooldown.is_stopped():
		dash_particle.emitting = true
		dash_cooldown.start()
		dash_speed = 2000


func _on_dash_cooldown_timeout():
	dash_cooldown.stop()
	
func attack():
	animated_sprite.play("attack")


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		animated_sprite.animation = "idle"


func _on_animated_sprite_2d_frame_changed():
	if animated_sprite == null: return
	if animated_sprite.animation == "attack":
		if animated_sprite.frame == 1:
			direction /= 10
		if animated_sprite.frame == 3:
			hurt_box.monitoring = true
			smear.visible = true
			if direction == Vector2.ZERO:
				if animated_sprite.scale.x >= 0:
					direction = Vector2.RIGHT
				else:
					direction = Vector2.LEFT
			direction = direction.normalized() * 2
		if animated_sprite.frame == 5:
			hurt_box.monitoring = false
			smear.visible = false
			direction /= 10

