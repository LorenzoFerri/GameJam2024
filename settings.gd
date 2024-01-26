extends Control

@onready var volume_slider = %VolumeSlider
@onready var master_bus_index = AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
	SceneManager.goto_scene("res://main_menu.tscn")


func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))
