extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@export var attack_range: float = 180.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var health_component = $HealthComponent
@onready var hp_label = $HpLabel
@onready var sprite = $Sprite
@onready var AI_component = $AIComponent
@onready var hit_box = $Hitbox


func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = attack_range
	navigation_agent.target_desired_distance = attack_range

	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	health_component.is_dead.connect(on_is_dead)
	

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		if not AI_component.is_attacking:
			AI_component.start_attack()
		return
	
	if AI_component.is_attacking:
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	sprite.play("walk")
	
	if velocity.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
	else:
		sprite.scale.x = abs(sprite.scale.x) * -1
		
	hit_box.look_at(next_path_position)
	
	move_and_slide()

func on_is_dead():
	queue_free()

func update_health(old_value, new_value):
	hp_label.text = str(new_value)
