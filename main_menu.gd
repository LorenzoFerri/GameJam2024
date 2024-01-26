extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_pressed():
	SceneManager.goto_scene("res://settings.tscn")


func _on_new_game_pressed():
	SceneManager.goto_scene("res://game.tscn")


func _on_exit_pressed():
	get_tree().quit()
