extends Spell

func _use():
	
	#var statuses: Dictionary = Globals.TileStatus
	var i = 0
	
	for tile in tile_board.get_tiles():
		tile.add_status(TileStatus.values()[i])
		tile.add_poofcloud(Globals.COLORS.CHASER_PINK,tile.get_color())
		i += 1
		
	_post_use()
