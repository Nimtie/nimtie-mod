extends CustomStatus

static func _static_init() -> void:
	face_color=[Color.WHITE,Color.WHITE]
	deboss_color=[Color("08235b"),Color("382932")]
	#wood_textures=[preload("res://mods/foggy_glasses/negative tile sprites/inverted_wood_tile.png")]
	#plastic_texture=preload("res://mods/foggy_glasses/negative tile sprites/inverted_plastic_tile.png")
	#wood_fish_textures=[[preload("res://mods/foggy_glasses/negative tile sprites/inverted_wood_fish_flipped.png")],[preload("res://mods/foggy_glasses/negative tile sprites/inverted_wood_fish.png")]]
	#plastic_fish_textures=[preload("res://mods/foggy_glasses/negative tile sprites/inverted_plastic_fish_flipped.png"),preload("res://mods/foggy_glasses/negative tile sprites/inverted_plastic_fish.png")]

func word_effect(_word_builder:WordBuilder,_warnings:Dictionary)->void:
	var glue_num = 0
	var glue_indexes = []
	for i in range(_word_builder.tiles.size()):
		glue_num += 1
		if _word_builder.tiles[i].get_status("glue"):
			glue_indexes.append(i)
	
	if glue_num != 1:
		for i in range(glue_indexes.size() - 1):
			if glue_indexes[i + 1] - glue_indexes[i] > 1:
				load("res://mods/framework/overrides_old/word_builder.gd").warning_priority.append("glue")
				_word_builder.add_warning_tile(_warnings, "glue", tile)
				break
		

	
		
