extends CharacterBody2D

var doggo_scene = preload("res://features/doggo/doggo.tscn")

@export var speed = 600.0
@export var damping = 0.6

@onready var dash_cooldown := $DashCooldown
var dash_speed = 0
@onready var dash_damping = 0.9
@onready var dash_particle := $DashParticles
@onready var animated_sprite := $AnimatedSprite2D
@onready var hit_box := $HitBox
@onready var smear := $HitBox/Smear
@onready var hp_bar := $CanvasLayer/HealtBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game := get_parent()
@onready var frenzy_particles := $FrenzyParticles
var direction = Vector2.ZERO
var last_direction: Vector2 = Vector2.RIGHT

@export var doggo_cooldown := 1.0
var doggo_cd_timer = 0

func _physics_process(delta):
	if animated_sprite.animation != "attack":
		var direction_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var direction_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		direction = Vector2(direction_x,direction_y).normalized()
		if direction.length() > 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
	if direction.length():
		last_direction = direction
		velocity = direction * speed + direction * dash_speed
		hit_box.rotation = direction.angle()
	else:
		velocity *= damping
	
	
		
	if direction.x > 0:
		animated_sprite.scale.x = abs(animated_sprite.scale.x)
	elif direction.x < 0:
		animated_sprite.scale.x = -abs(animated_sprite.scale.x)
		
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
	
	if doggo_cd_timer > 0:
		doggo_cd_timer -= delta
		
	if Input.is_action_just_pressed("dash"):
		dash()
		
	if Input.is_action_just_pressed("attack") and animated_sprite.animation != "attack":
		attack()
	if Input.is_action_just_pressed("doggo") and animated_sprite.animation != "attack":
		launch_doggo()
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
	animated_sprite.offset = Vector2(125, -80)
	dash_particle.process_material.emission_shape_offset = Vector3(60, -40, 0)


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		animated_sprite.play("idle")
		animated_sprite.offset = Vector2.ZERO
		dash_particle.process_material.emission_shape_offset = Vector3.ZERO


func _on_animated_sprite_2d_frame_changed():
	if animated_sprite == null: return
	if animated_sprite.animation == "attack":
		if animated_sprite.frame == 1:
			direction /= 10
		if animated_sprite.frame == 4:
			for body in hit_box.get_overlapping_areas():
				hit_body(body)
			smear.visible = true
			if direction == Vector2.ZERO:
				direction = last_direction
			direction = direction.normalized() * 2
		if animated_sprite.frame == 6:
			smear.visible = false
			direction /= 10

func update_health(old_value, new_value):
	hp_bar.value = new_value

func hit_body(body):
	if body.get_parent().get_name() == "Player":
		return
	if body.get_name() == "HitBox":
		return
	var hp_comp = body.get_parent().get_node_or_null("HealthComponent")
	if hp_comp != null:
		hp_comp.take_damage(10)
		game.increase_frenzy(8)

func set_on_frenzy(val: bool):
	frenzy_particles.visible = val

func _on_health_component_is_dead():
	SceneManager.lose_skill()
	
func _on_health_component_took_damage(old_value, new_value):
	animation_player.play("took_damage")

func launch_doggo():
	if doggo_cd_timer > 0:
		return
	doggo_cd_timer = doggo_cooldown
	var doggo = doggo_scene.instantiate()
	doggo.global_position = global_position
	doggo.global_position.y += 100
	
	var direction_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var direction_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	doggo.direction = Vector2(direction_x, direction_y).normalized()
	if doggo.direction.length() == 0:
		doggo.direction = last_direction.normalized()
	
	add_sibling(doggo)
