extends Control

const nero = preload("res://assets/intro/nero.png")

var slides = [
	Slide.new("Text 1", nero),
	Slide.new("Text 2", nero),
	Slide.new("Text 3", nero),
	Slide.new("Text 4", nero),
	Slide.new("Text 5", nero)
]

var current = 0

func _ready():
	pass
	
func _on_next_pressed():
	if (current + 1 > len(slides)):
		SceneManager.goto_scene("res://game.tscn")
	else:
		current += 1
