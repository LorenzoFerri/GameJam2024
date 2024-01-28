extends Control

@export var images: Array[Texture]
@export var next_scene: String

var current = 0
var elapsed = 0

func _ready():
	$SlideImage.texture = images[current]
	
func _process(delta):
	check_next()
	

func check_next():
	if Input.is_action_just_pressed("next"):
		if current + 1 >= len(images):
			SceneManager.goto_scene(next_scene)
		else:
			current += 1
			elapsed = 0
			$SlideImage.texture = images[current]

	
