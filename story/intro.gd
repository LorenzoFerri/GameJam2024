extends Control

var slides = [
	Slide.new(
		"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas mollis et purus sed rhoncus. Pellentesque varius aliquet sagittis. Integer nec semper arcu, eget viverra nibh. Mauris eu urna sapien. Donec in urna lectus. Duis vehicula ac lorem a auctor. Praesent scelerisque tempus massa id sodales.",
		preload("res://assets/intro/s1.png")
	),
	Slide.new(
		"Vestibulum placerat enim non est eleifend laoreet. Suspendisse pulvinar quam ut mi gravida, luctus tempor mi faucibus. Aliquam turpis nulla, volutpat ut ante vel, viverra viverra ligula. Nulla ut blandit risus. Aenean gravida imperdiet libero, vitae consequat erat lacinia id. Aenean iaculis nec est vel molestie.",
		preload("res://assets/intro/s2.png")
	),
	Slide.new(
		"Morbi pretium massa sit amet ligula malesuada, eget euismod purus hendrerit. Quisque tincidunt lobortis lorem, ac tempus leo pharetra et. Suspendisse a quam non ipsum iaculis commodo. Donec cursus vel nulla sed dictum. Sed eros est, ultrices in lectus id, venenatis molestie nibh.",
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
	
