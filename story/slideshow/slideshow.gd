extends Control

@export var images: Array[Texture]
@export var texts: Array[String]

var current = 0
var elapsed = 0

func _ready():
	assert(len(texts) == len(images), "Must have same number of images and texts")
	$SlideImage.texture = images[current]
	$NarrationText.text = texts[current]
	
func _process(delta):
	show_text(delta)
	check_next()
	

func check_next():
	if Input.is_action_just_pressed("next"):
		if $NarrationText.visible_ratio < 1.0:
			elapsed = 1000000
		elif current + 1 >= len(images):
			SceneManager.goto_scene("res://game.tscn")
		else:
			current += 1
			elapsed = 0
			var text = texts[current]
			$SlideImage.texture = images[current]
			$NarrationText.visible = len(text) > 0
			$NarrationText.text = text

func show_text(delta):
	elapsed += delta
	$NarrationText.visible_characters = elapsed/0.04
	
