extends Player


func _init():
 id = "nimtie"
 starting_spells = ["nimtie_mod:expand"]
 

func get_gender():
 if is_trans():
  return Gender.FEMALE
 else:
  return Gender.MALE
