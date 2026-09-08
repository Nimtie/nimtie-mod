extends Player

var damage_sound = load("res://mods/nimtie_mod/sounds/e.wav")

func _init():
	id = "nimtie"
	starting_spells = ["nimtie_mod:expand"]

func get_gender():
	if is_trans():
		return Gender.FEMALE
	else:
		return Gender.MALE
