extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_on_new_game_focus_entered()
	$"VBoxContainer/New Game".grab_focus()
	$MainSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouse and event.is_pressed():
		$ColorRect.visible = false
		$CreditsIcon.visible = false
		
	if event is InputEventKey and event.pressed:
		if event.keycode != KEY_ENTER:
			$ColorRect.visible = false
			$CreditsIcon.visible = false

func _on_settings_pressed():
	#SceneManager.goto_scene("res://settings.tscn")
	$ColorRect.visible = true
	$CreditsIcon.visible = true


func _on_new_game_pressed():
	SceneManager.goto_scene("res://story/intro.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_new_game_focus_entered():
	$Popipo.play()
	$NewGameArrow.visible = true
	$NewGameArrow.modulate = Color(randf(), randf(), randf(), 1)


func _on_new_game_focus_exited():
	$NewGameArrow.visible = false


func _on_credits_focus_entered():
	$Popipo.play()
	$CreditsArrow.visible = true
	$CreditsArrow.modulate = Color(randf(), randf(), randf(), 1)
	


func _on_credits_focus_exited():
	$CreditsArrow.visible = false


func _on_exit_focus_entered():
	$Popipo.play()
	$ExitArrow.visible = true
	$ExitArrow.modulate = Color(randf(), randf(), randf(), 1)


func _on_exit_focus_exited():
	$ExitArrow.visible = false
