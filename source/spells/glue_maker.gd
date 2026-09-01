extends TileModifierSpell

func apply_to_tile(tile: Tile, _real_tile: Tile, is_preview: bool, _is_preview_update: bool) -> void :
	tile.add_status("glue")
	if not is_preview:
		tile.add_poofcloud(Globals.COLORS.CHASER_PINK,tile.get_color())
		tile.animation.play("pressed")
	
func is_tile_selectable(tile: Tile) -> bool:
	return not tile.has_harmful_status()
