extends Spell

func get_diagonal(coords):
	var column_coords = tile_board.get_column_coords()
	var row_coords = tile_board.get_row_coords()
	var corners = [Vector2i(0, 0), 
				   Vector2i(column_coords.size() - 1, 0),
				   Vector2i(0, row_coords.size() - 1), 
				   Vector2i(column_coords.size() - 1, 
							row_coords.size() - 1)]
	var min = mini(column_coords.size(), row_coords.size())
	var diagonal = []
	
	if (coords == corners[0]):
		for i in range(min):
			diagonal.append(tile_board.get_tile_at(coords))
			coords += Vector2i(1, 1)
		
	elif (coords == corners[1]):
		for i in range(min):
			diagonal.append(tile_board.get_tile_at(coords))
			coords += Vector2i(-1, 1)
		
	elif (coords == corners[2]):
		for i in range(min):
			diagonal.append(tile_board.get_tile_at(coords))
			coords += Vector2i(1, -1)
		
	elif (coords == corners[3]):
		for i in range(min):
			diagonal.append(tile_board.get_tile_at(coords))
			coords += Vector2i(-1, -1)
		
	return diagonal

func _use():
	var tile = await get_selection()

	if tile == null:
		_end_use()
		return
		
	var coords = tile.get_coord()
	var tiles_coords = get_diagonal(coords)
	tile_board.remove_tiles(tiles_coords, {
		interval = 0.08, 
		poof_blend = Globals.COLORS.BLEND_SMOKE, 
		tile_color = true, 
	})

	_post_use()
	
func is_tile_selectable(tile: Tile) -> bool:
	var diagonal = get_diagonal(tile.get_coord())
	return !diagonal.is_empty()
