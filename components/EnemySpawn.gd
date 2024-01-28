extends Marker2D

@onready var infermiera_spawn = $InfermieraSpawn
@onready var medico_spawn = $MedicoSpawn

func spawn(type):
	if type == "i":
		infermiera_spawn.spawn_enemy()
	else:
		medico_spawn.spawn_enemy()
