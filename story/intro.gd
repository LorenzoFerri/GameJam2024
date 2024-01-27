extends Control

var slides = [
	Slide.new(
		"Il clown prova a far ridere il bambino malato, ma il bambino non sembra divertito.",
		preload("res://assets/intro/s1.png")
	),
	Slide.new(
		"Un'infermiera entra e inciampa cadendo di faccia.",
		preload("res://assets/intro/s2.png")
	),
	Slide.new(
		"Il bambino scoppia a ridere. Il clown capisce che per divertire il bambino serve la violenza.",
		preload("res://assets/intro/s3.png")
	),
]

var current = 0
var elapsed = 0

func _ready():
	$SlideImage.texture = slides[current].image
	$NarrationText.text = slides[current].text
	
func _process(delta):
	show_text(delta)
	check_next()
	

func check_next():
	if Input.is_action_just_pressed("next"):
		if $NarrationText.visible_ratio < 1.0:
			elapsed = 1000000
		elif current + 1 >= len(slides):
			SceneManager.goto_scene("res://game.tscn")
		else:
			current += 1
			elapsed = 0
			$SlideImage.texture = slides[current].image
			$NarrationText.text = slides[current].text

func show_text(delta):
	elapsed += delta
	$NarrationText.visible_characters = elapsed/0.04
	
