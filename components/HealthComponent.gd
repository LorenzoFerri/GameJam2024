extends Node

signal took_damage(old_value, new_value)
signal healed_damage(old_value, new_value)
signal is_dead

var hp: float = 100.0
@export var maxHp: float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = maxHp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(amount: float):
	if amount <= 0:
		return
	
	var old_hp = hp
	hp -= amount
	
	if hp <= 0:
		is_dead.emit()
	
	took_damage.emit(old_hp, hp)

func heal_damage(amount: float):
	if amount <= 0:
		return
	
	var old_hp = hp
	hp += amount
	
	healed_damage.emit(old_hp, hp)
