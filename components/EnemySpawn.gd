extends Marker2D

@onready var infermiera_spawn = $InfermieraSpawn
@onready var medico_spawn = $MedicoSpawn

func is_finish():
	var enemies_on_screen = infermiera_spawn.get_enemy_on_screen() + medico_spawn.get_enemy_on_screen()
	
	return infermiera_spawn.is_finish() && medico_spawn.is_finish() && enemies_on_screen == 0
