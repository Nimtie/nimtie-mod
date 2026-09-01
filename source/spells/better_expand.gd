extends "res://mods/nimtie_mod/source/spells/expand.gd"

func init_expanded_board():
	super()
	insertStatusesFunction([TileStatus.ENHANCED], 0.15, [1.0], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 4)
