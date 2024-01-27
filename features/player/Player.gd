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
@onready var hp_label := $HpLabel
@onready var game := get_parent()
var direction = Vector2.ZERO
var last_direction: Vector2 = Vector2.RIGHT

func _physics_process(delta):
	if animated_sprite.animation != "attack":
		var direction_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var direction_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		direction = Vector2(direction_x,direction_y).normalized()
	if direction.length():
		last_direction = direction
		velocity = direction * speed + direction * dash_speed
		hurt_box.rotation = direction.angle()
	else:
		velocity *= damping
	
		
	if direction.x > 0:
		animated_sprite.scale.x = 0.5
	elif direction.x < 0:
		animated_sprite.scale.x = -0.5
		
	var frame_index: int = animated_sprite.get_frame()
	var animation_name: String = animated_sprite.animation
	var sprite_frames: SpriteFrames = animated_sprite.get_sprite_frames()
	var current_texture: Texture2D = sprite_frames.get_frame_texture(animation_name, frame_index)
	if animated_sprite.scale.x < 0:
		var image = current_texture.get_image()
		image.flip_x()
		current_texture = ImageTexture.create_from_image(image)
	dash_particle.texture = current_texture
		
	dash_speed *= dash_damping
	
	if dash_speed <= 200:
		dash_particle.emitting = false
		set_collision_mask_value(2, true)
		
	if Input.is_action_just_pressed("dash"):
		dash()
		
	if Input.is_action_just_pressed("attack") and animated_sprite.animation != "attack":
		attack()
	move_and_slide()

	

func dash():
	if dash_cooldown.is_stopped():
		dash_particle.emitting = true
		set_collision_mask_value(2, false)
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
			for body in hurt_box.get_overlapping_bodies():
				print(body)
				hit_body(body)
			smear.visible = true
			if direction == Vector2.ZERO:
				direction = last_direction
			direction = direction.normalized() * 2
		if animated_sprite.frame == 5:
			smear.visible = false
			direction /= 10

func update_health(old_value, new_value):
	hp_label.text = str(new_value)

func hit_body(body):
	if body.get_name() == "Player":
		return
	var hp_comp = body.get_node_or_null("HealthComponent")
	if hp_comp != null:
		hp_comp.take_damage(10)
		game.increase_frenzy(4)

func set_on_frenzy(val: bool):
	print("On Frenzy")


func _on_health_component_is_dead():
	get_tree().quit()
