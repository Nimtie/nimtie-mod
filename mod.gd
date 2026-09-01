extends Mod

var SPELLS: Dictionary[String, String] = {
	DIAGONAL_BOARD_SHEAR = "diagonal_board_shear",
	LONG_CRIT_MAKER = "long_crit_maker",
	UWUIFIED_WORD = "uwuified_word",
	GLUE_MAKER = "glue_maker",
	EXPAND = "expand",
	BETTER_EXPAND = "better_expand",
	HODGE_PODGE = "hodge_podge"
}

var SPELL_POOL: Dictionary[String, float] = {
	SPELLS.DIAGONAL_BOARD_SHEAR: 0.0,
	SPELLS.LONG_CRIT_MAKER: 0.0,
	SPELLS.UWUIFIED_WORD: 0.0,
	SPELLS.GLUE_MAKER: 0.0,
	SPELLS.EXPAND: 0.0,
	SPELLS.BETTER_EXPAND: 0.0,
	SPELLS.HODGE_PODGE: 0.0
}

var SPELL_CATEGORIES: Dictionary[String, Array] = {
	Globals.SPELL_CATEGORY.SUPPORT: [
		SPELLS.DIAGONAL_BOARD_SHEAR,
		SPELLS.UWUIFIED_WORD,
		SPELLS.GLUE_MAKER,
		SPELLS.EXPAND,
		SPELLS.BETTER_EXPAND,
		SPELLS.HODGE_PODGE
	],
	Globals.SPELL_CATEGORY.OFFENSIVE: [
		SPELLS.LONG_CRIT_MAKER
	]
	
}



func _init() -> void:
	print("Nimtie Mod initialized")
	CustomIntent.custom_intent_icons["damage_divider"]=preload("res://mods/nimtie_mod/arte/intent/damage_divider.png")
	CustomIntent.custom_intent_icons["defense_divider"]=preload("res://mods/nimtie_mod/arte/intent/defense_multiply.png")
	CustomIntent.custom_intent_icons["alter_spell"]=preload("res://mods/nimtie_mod/arte/intent/alter_spell.png")
	CharacterLoader.add_character("nimtie", "nimtie_mod:expand",preload("res://mods/nimtie_mod/arte/characters/nimtie_icons.png"))
	CharacterLoader.custom_spell_upgrades["nimtie_mod:expand"]="nimtie_mod:better_expand"
	CharacterLoader.speech_bubbles["nimtie"]=["res://mods/nimtie_mod/arte/bubbles/nimtie_speech_bubble.png","res://mods/nimtie_mod/arte/bubbles/nimtie_speech_bubble_tail.png"]
func _post_mods_loaded() -> void:
	print("Nimtie Sees All (Mods)")
	

func modify_spell_pool(pool: Dictionary, category: String = "") -> void:
	super(pool, category)
	if Game.player.id == "nimtie":
		pool.erase("two_point_leading")


## Returns a list of spell ids for the game to load into SpellData
## The ids must be namespaced as "modid:spellid" or the game won't like it!
## Convenience functions exist to do so.
func get_spell_ids() -> Array[String]:
	return namespace_ids(SPELLS.values())


## Returns a dictionary {spell_id: weight}
## You are expected to filter appropriately to the requested category!
## The SpellData.get_filtered_spell_pool function makes that convenient, though.
## And again, namespace!
func get_spell_pool(category: String = "") -> Dictionary[String, float]:
	var category_pool: Array = SPELL_CATEGORIES.get(category, [])
	var pool := SpellData.get_filtered_spell_pool(SPELL_POOL, category_pool)
	return namespace_dictionary_ids(pool)
