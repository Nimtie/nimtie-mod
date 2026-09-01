extends CustomStatus


static func _static_init() -> void:
	face_color=[Color.WHITE,Color.WHITE]
	deboss_color=[Color("08235b"),Color("382932")]
	#wood_textures=[preload("res://mods/foggy_glasses/negative tile sprites/inverted_wood_tile.png")]
	#plastic_texture=preload("res://mods/foggy_glasses/negative tile sprites/inverted_plastic_tile.png")
	#wood_fish_textures=[[preload("res://mods/foggy_glasses/negative tile sprites/inverted_wood_fish_flipped.png")],[preload("res://mods/foggy_glasses/negative tile sprites/inverted_wood_fish.png")]]
	#plastic_fish_textures=[preload("res://mods/foggy_glasses/negative tile sprites/inverted_plastic_fish_flipped.png"),preload("res://mods/foggy_glasses/negative tile sprites/inverted_plastic_fish.png")]
	
func intent_exists(string: String, tile2: Tile, value: int = 0):
	Game.word_builder.intent_tiles.get_or_add(string, []).append(tile2)
	var intent_value = Game.word_builder.intent_value
	if string in intent_value:
		intent_value[string] += value
		return true
	else:
		intent_value[string] = value
		return false

func multiplier(_word_builder:WordBuilder): 
	
	if _word_builder.damage_multiplier < 1 and intent_exists("damage_divider", tile) == false:
		
		_word_builder.add_intent("damage_divider", {multiplier = _word_builder.damage_multiplier})

	if _word_builder.defense_multiplier < 1 and intent_exists("defense_divider", tile) == false:
		
		_word_builder.add_intent("defense_divider", {multiplier = _word_builder.defense_multiplier})

func word_effect(_word_builder:WordBuilder,_warnings:Dictionary)->void:
	
	
	var words: WordList = _word_builder.get_words()
	var crit_addition: float = Game.balance.crit_value - 1
	
	if _word_builder.can_submit() == true and words.maximum_length > 6:
		if tile.type == TileType.DAMAGE:
			_word_builder.damage_multiplier += crit_addition
		else:
			_word_builder.defense_multiplier += crit_addition
		
	else:
		if tile.type == TileType.DAMAGE:
			_word_builder.damage_multiplier = crit_addition
		else:
			_word_builder.defense_multiplier = crit_addition
	multiplier(_word_builder)
	
func board_effect(_word_builder:WordBuilder,_warnings:Dictionary)->void:
	_word_builder.add_intent_tile(_word_builder.Intent.POISON, tile, Game.balance.bleed_damage)

static func board_trigger(_tile_board: TileBoard) -> void:
	var long_crit_damage = 0
	for tile2 in _tile_board.get_tiles():
		if tile2.has_status("long_crit"):	
			long_crit_damage += Game.balance.bleed_damage
	Game.player.hurt(long_crit_damage)
	Game.word_builder.remove_intent(CustomIntent.Intent.POISON)
			

		
