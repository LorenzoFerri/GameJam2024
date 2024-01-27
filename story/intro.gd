extends Control

var slides = [
	Slide.new("Text 1", preload("res://assets/intro/s1.png")),
	Slide.new("Text 2", preload("res://assets/intro/s2.png")),
	Slide.new("Text 3", preload("res://assets/intro/s3.png")),
]

var current = 0
var elapsed = 0

func _ready():
	#$SlideImage.texture = slides[current].image
	$NarrationText.text = slides[current].text
	
func _process(delta):
	check_next()
	show_text(delta)

func check_next():
	if Input.is_action_pressed("next"):
		if (current + 1 > len(slides)):
			SceneManager.goto_scene("res://game.tscn")
		else:
			current += 1
			elapsed = 0
			#$SlideImage.texture = slides[current].image
			$NarrationText.text = slides[current].text

func show_text(delta):
	elapsed += delta
	$NarrationText.visible_characters = elapsed/0.08
