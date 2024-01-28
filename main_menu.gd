extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_new_game_focus_entered()
	$"VBoxContainer/New Game".grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouse and event.is_pressed():
		$ColorRect.visible = false
		
	if event is InputEventKey and event.pressed:
		if event.keycode != KEY_ENTER:
			$ColorRect.visible = false

func _on_settings_pressed():
	#SceneManager.goto_scene("res://settings.tscn")
	$ColorRect.visible = true


func _on_new_game_pressed():
	SceneManager.goto_scene("res://story/intro.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_new_game_focus_entered():
	$NewGameArrow.visible = true


func _on_new_game_focus_exited():
	$NewGameArrow.visible = false


func _on_credits_focus_entered():
	$CreditsArrow.visible = true


func _on_credits_focus_exited():
	$CreditsArrow.visible = false


func _on_exit_focus_entered():
	$ExitArrow.visible = true


func _on_exit_focus_exited():
	$ExitArrow.visible = false
