extends Spell


var first_face
var second_face
var tile: Tile
#var inflation_sound = load("res://mods/nimtie_mod/sounds/balloon_inflate.wav")
#var deflation_sound = load("res://mods/nimtie_mod/sounds/balloon_deflate.wav")
var rub_sound = load("res://mods/nimtie_mod/sounds/balloon_rub.wav")
var CoordTarget = load("res://source/effects/coord_target.tscn")


func get_applied_face(use_rng: RNG = rng.move) -> String:
	var bigram: = Letters.pick_from_pool(Letters.BIGRAMS, use_rng, {
		must_have_vowel = true, 
		min_weight = 0.5, 
		backup_cutoff = 0.5, 
	})
	var replace_character = use_rng.randi_range(0, 1)
	for letter in bigram:
		if letter in Letters.CONSONANTS:
			replace_character = bigram.find(letter)
	bigram[replace_character] = "*"
	return bigram

func insertStatusesFunction(statussies: Array[String], chance_for_status: float, 
					specific_status_chance: Array[float], letters: Variant,
					max_tiles: int, expandedSize = [5,5], typing: bool = false, slashed = false):
	var tile_num = 0
	var help = ""
	
	if !tile_board.has_flag("phone_board") and Game.enemy.get_unit_name() != "Nobody":
		expandedSize = [5,5]
	
	for i in expandedSize[0] - 1:
		help = letters.call()
		
		if statussies.has(TileStatus.LINKED) and Game.enemy.get_unit_name() == "Umami":
			if randi_range(1,3) == 1:
				statussies = [TileStatus.LINKED, TileStatus.BLEED]
		
		if slashed == true:
			first_face = Letters.get_random_letter(null, Game.random)
			second_face = Letters.get_random_letter(null, Game.random, [first_face])
		
		if statussies.has(TileStatus.CRIT) and Game.enemy.get_unit_name() == "Bammon":
			help = [help[0], help[1]]
			
		
		if (Game.random.randf_range(0,1) <= chance_for_status and tile_num < max_tiles):
			var queued_tile = tile_board.queue.get_preview(i, 0)
			
			
			if Game.enemy.get_unit_name() == "Umami":
				queued_tile.statuses = statussies
				statussies = [TileStatus.LINKED]
				tile_num += 1
				continue
			elif Game.random.randf_range(0,1) <= specific_status_chance[0]:	
				if "statuses" in queued_tile:
					queued_tile.statuses.append(statussies[0])
				else:
					queued_tile.statuses = [statussies[0]]
			else:
				if "statuses" in queued_tile:
					queued_tile.statuses.append(statussies[1])
				else:
					queued_tile.statuses = [statussies[1]]
			queued_tile.faces = help
			
			if slashed == true:
				queued_tile.slashed_faces = [first_face, second_face]
			if typing == true:
				if Game.random.randi_range(1,2) == 1:
					queued_tile.type = TileType.DAMAGE
				else:
					queued_tile.type = TileType.DEFENSE
			tile_num += 1
	
	if !tile_board.has_flag("phone_board") and Game.enemy.get_unit_name() != "Nobody":
		expandedSize = [5,5]
		
	for i in expandedSize[1]:
		help = letters.call()
		
		
		if statussies.has(TileStatus.LINKED) and Game.enemy.get_unit_name() == "Umami":
			if randi_range(1,3) == 1:
				statussies = [TileStatus.LINKED, TileStatus.BLEED]
		
		if slashed == true:
			first_face = Letters.get_random_letter(null, Game.random)
			second_face = Letters.get_random_letter(null, Game.random, [first_face])
			
		if statussies.has(TileStatus.CRIT) and Game.enemy.get_unit_name() == "Bammon":
			help = [help[0], help[1]]
			
		if statussies.has(TileStatus.ACID):
			break
		
		if (Game.random.randf_range(0,1) <= chance_for_status and tile_num < max_tiles):
			if Game.random.randf_range(0,1) <= specific_status_chance[0]:
				if Game.enemy.get_unit_name() == "Nobody" and Game.enemy.next_move == "nimtie_d":
					tile_board.queue.insert_queued_tile_at({
					statuses = [statussies[0]], 
					faces = [Letters.get_random_letter(tile_board.get_letter_census())],
					type = Game.random.pick_random([TileType.DAMAGE, TileType.DEFENSE])
					}, Vector2i(5, 0))
				
				if Game.enemy.get_unit_name() == "Umami":
					tile_board.queue.insert_queued_tile_at({
					statuses = statussies, 
					faces = help
					}, Vector2i(4, 0))
					tile_num += 1
					statussies = [TileStatus.LINKED]
					continue
				
				if typing == true:
					tile_board.queue.insert_queued_tile_at({
					statuses = [statussies[0]], 
					faces = help,
					type = Game.random.pick_random([TileType.DAMAGE, TileType.DEFENSE])
					}, Vector2i(4, 0))
					
				elif slashed == true:
					tile_board.queue.insert_queued_tile_at({
					statuses = [statussies[0]], 
					faces = help,
					slashed_faces = [first_face, second_face],
					}, Vector2i(4, 0))
					
				else:
					tile_board.queue.insert_queued_tile_at({
					statuses = [statussies[0]], 
					faces = help,
					}, Vector2i(4, 0))
			elif typing == true:
				tile_board.queue.insert_queued_tile_at({
					statuses = [statussies[1]], 
					faces = help,
					type = Game.random.pick_random([TileType.DAMAGE, TileType.DEFENSE])
					}, Vector2i(4, 0))
			else: 
				tile_board.queue.insert_queued_tile_at({
					statuses = [statussies[1]], 
					faces = help,
					}, Vector2i(4, 0))
			tile_num += 1
	
func post_expanded_board():
	if Game.enemy.get_unit_name() == "Strawman" or Game.enemy.get_unit_name() == "Housebroken" or Game.enemy.get_unit_name() == "Paradigm" or Game.enemy.get_unit_name() == "Copycat":
		var col_tiles = tile_board.get_tiles(
			{columns = [4]})
		var row_tiles = tile_board.get_tiles(
			{rows = [4]})
			
		for tile2 in col_tiles:
			if tile2.get_status(TileStatus.BOMB):
				tile2.add_status(TileStatus.BOMB, 1)
		for tile2 in row_tiles:
			if tile2.get_status(TileStatus.BOMB):
				tile2.add_status(TileStatus.BOMB, 1)
	if Game.enemy.get_unit_name() == "Umami" or Game.enemy.get_unit_name() == "Salt":
		var link_colors = [Globals.LinkColor.COBALT, Globals.LinkColor.GOLD, Globals.LinkColor.GRAY]
		var col_tiles = tile_board.get_tiles(
			{columns = [4]})
		var row_tiles = tile_board.get_tiles(
			{rows = [4]})
			
		for tile2 in col_tiles:
			if tile2.get_status(TileStatus.LINKED):
				tile2.add_status(TileStatus.LINKED, Game.random.pick_random(link_colors))
		for tile2 in row_tiles:
			if tile2.get_status(TileStatus.LINKED):
				tile2.add_status(TileStatus.LINKED, Game.random.pick_random(link_colors))
func _use():
	

	AudioManager.play_sound(rub_sound, 1.5, 2.0)
	
	var targets = tile_board.get_targeted_coords()
	
	if targets.size() > 0:
		for target in targets:
			target.clear()
		
	init_expanded_board()
	if Game.enemy.get_unit_name() == "Receiver" and tile_board.has_flag("phone_board"):
		await tile_board.set_size(3, 4, null, null, false, .66, TileBoard.ExpandMode.TOP_RIGHT)
	elif Game.enemy.get_unit_name() == "Nobody" and Game.enemy.next_move == "nimtie_a":
		await tile_board.set_size(5, 5, null, null, false, .66, TileBoard.ExpandMode.CENTER)
	elif Game.enemy.get_unit_name() == "Nobody" and Game.enemy.next_move == "nimtie_b":
		await tile_board.set_size(4, 6, null, null, false, .66, TileBoard.ExpandMode.TOP_RIGHT)
	elif Game.enemy.get_unit_name() == "Nobody" and Game.enemy.next_move == "nimtie_c":
		await tile_board.set_size(3, 4, null, null, false, .66, TileBoard.ExpandMode.TOP_RIGHT)
	elif Game.enemy.get_unit_name() == "Nobody" and Game.enemy.next_move == "nimtie_d":
		await tile_board.set_size(6, 3, null, null, false, .66, TileBoard.ExpandMode.TOP_RIGHT)
	else:
		await tile_board.set_size(5, 5, null, null, false, .66, TileBoard.ExpandMode.CENTER)
	
	post_expanded_board()
	
	for target in targets:
		var coord = tile_board.get_status_coord(target)
		var coord_target = CoordTarget.instantiate()
		tile_board.set_coord_status(coord, coord_target)
	
	if Game.enemy.get_unit_name() != "Nobody":
		Game.enemy.dooming_columns = [4]
		tile_board.set_doomed_rows([0])
	_post_use()

	
func turn_end():
	await tile_board.settle_board()
	
func init_expanded_board():
	var enemy_name = Game.enemy.get_unit_name()
	
	if has_curse(CURSE.CURSED):
		insertStatusesFunction([TileStatus.CURSED], 0.25, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 3)
	if enemy_name == "Noppy":
		insertStatusesFunction([TileStatus.ASH], 0.9, [1.0], func (): return ["z"], 7)
	elif enemy_name == "Soppy":
		insertStatusesFunction([TileStatus.ASH], 0.8, [1.0], func (): return ["mi"], 6)
	elif enemy_name == "Stoker":
		insertStatusesFunction([TileStatus.COAL], 0.6, [1.0], func (): return [""], 6)
	elif enemy_name == "Broker":
		insertStatusesFunction([TileStatus.MONEY], 0.1, [1.0], func (): return ["*"], 2)
	elif enemy_name == "Bookworm":
		insertStatusesFunction([TileStatus.SPICY], 0.7, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 7)
	elif enemy_name == "Milkworm":
		insertStatusesFunction([TileStatus.GUNK], 0.5, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 6)
	elif enemy_name == "People":
		insertStatusesFunction([TileStatus.POISON], 0.25, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 4)
	elif enemy_name == "Fat Cat":
		insertStatusesFunction([TileStatus.BLEED], 0.35, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 4)
	elif enemy_name == "Purrgeoisie":
		insertStatusesFunction([TileStatus.BRUISE], 0.35, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 4)
	elif enemy_name == "Anti-Sex Worker":
		insertStatusesFunction([TileStatus.BLEED], 0.5, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 5)
	elif enemy_name == "Sex Traitor":
		insertStatusesFunction([TileStatus.BLEED], 0.5, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 5)
	elif enemy_name == "Snowball":
		insertStatusesFunction([TileStatus.ASH], 0.9, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 8)
	elif enemy_name == "Paddlers":
		insertStatusesFunction([TileStatus.GAY], 0.5, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 6, [5,5], true)
	elif enemy_name == "Social Climbers":
		insertStatusesFunction([TileStatus.ASH, TileStatus.BLEED], 0.1, [0.5, 0.5],  func (): return [Game.random.pick_random(["♥", "♦", "♠", "♣"])], 2)
	elif enemy_name == "Freezer":
		insertStatusesFunction([TileStatus.FROZEN], 0.1, [1.0], func(): return ["*"], 2)
	elif enemy_name == "Foreign Body":	
		insertStatusesFunction([TileStatus.FROZEN], 0.2, [1.0], func(): return ["/"], 3, [5,5], false, true)
	elif enemy_name == "Liquid Human":
		insertStatusesFunction([TileStatus.BLEED], 0.2, [1.0], func(): return [Letters.get_random_bigram(null, Game.random)], 2)
	elif enemy_name == "Proto-Cop":
		insertStatusesFunction([TileStatus.BLEED], 0.2, [1.0], func(): return [Letters.get_random_trigram(Game.random)], 1)
	elif enemy_name == "Strawman":
		insertStatusesFunction([TileStatus.BOMB], 0.1, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 2)
	elif enemy_name == "Housebroken":
		insertStatusesFunction([TileStatus.BOMB], 0.1, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 2)
	elif enemy_name == "Greeb":
		insertStatusesFunction([TileStatus.ASH], 0.3, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 5)	
	elif enemy_name == "Dew Jubilist":
		insertStatusesFunction([TileStatus.ACID], 0.5, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 4)
	elif enemy_name == "Dew Jubajalist":
		insertStatusesFunction([TileStatus.ACID], 0.5, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 3)
	elif enemy_name == "Xrafstar": 
		if Game.enemy.next_move == "pollute":
			insertStatusesFunction([TileStatus.POOP], 0.9, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 8)
		elif Game.enemy.next_move == "extrude" and Game.enemy.times_performed_move.pollute > 0:
			insertStatusesFunction([TileStatus.POISON], 0.4, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 6)
	elif enemy_name == "Pseud":
		insertStatusesFunction([TileStatus.POOP], 0.9, [1.0], func (): return [Letters.get_random_letter(tile_board.get_letter_census())], 8)
	elif enemy_name == "Prole Service":
		insertStatusesFunction([TileEffect.NUMBER], 0.2, [1.0], func (): return [Game.random.pick_random(Letters.NUMPAD_CHARACTERS.keys())], 4)
	elif enemy_name == "Receiver":
		if Game.enemy.next_move == "smash":
			insertStatusesFunction([TileEffect.NUMBER], 0.2, [1.0], func (): return [Game.random.pick_random(Letters.NUMPAD_CHARACTERS.keys())], 4)
		elif Game.enemy.next_move == "bash":
			insertStatusesFunction([TileEffect.NUMBER], 1, [1.0], func (): if Game.random.randi_range(1,9) == 1: return ["*"] else: return [Game.random.pick_random(Letters.NUMPAD_CHARACTERS.keys())], 3, [4,0])
	elif enemy_name == "Herrara":
		insertStatusesFunction([TileStatus.BRUISE], 0.4, [1.0], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 5)
	elif enemy_name == "Juvenile":
		insertStatusesFunction([TileStatus.BRUISE, TileStatus.BLEED], 0.4, [0.5,0.5], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 5)
	elif enemy_name == "Rubber Animal":
		insertStatusesFunction([TileStatus.BLEED], 0.1, [1.0], func(): return ["*"], 2)
	elif enemy_name == "Pink Rubber Animal":
		insertStatusesFunction([TileStatus.BLEED], 0.1, [1.0], func(): return [get_applied_face(Game.random)], 2)
	elif enemy_name == "Paradigm":
		insertStatusesFunction([TileStatus.BOMB], 0.1, [1.0], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 3)
	elif enemy_name == "Copycat":
		insertStatusesFunction([TileStatus.BOMB], 0.1, [1.0], func(): return [Game.random.pick_random(Letters.WILDCARD_GROUPS.keys())], 3)
	elif enemy_name == "Umami":
		insertStatusesFunction([TileStatus.LINKED], 0.45, [1.0], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 5)
	elif enemy_name == "Salt":
		insertStatusesFunction([TileStatus.LINKED], 0.5, [1.0], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 6)
	elif enemy_name == "New Cop":
		insertStatusesFunction([TileStatus.BRUISE], 0.4, [1.0], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 4)
	elif enemy_name == "Sheriff":
		insertStatusesFunction([TileStatus.BRUISE], 0.4, [1.0], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 4)	
	elif enemy_name == "Oenone":
		insertStatusesFunction([TileStatus.BLEED], 0.3, [1.0], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 4)
	elif enemy_name == "Parasite":
		insertStatusesFunction([TileStatus.ETERNAL], 0.15, [1.0], func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 2)
	elif enemy_name == "Bammon":
		insertStatusesFunction([TileStatus.CRIT], 0.1, [1.0], func(): return Letters.get_random_swap(), 2, [5,5], true)	
	elif enemy_name == "Nobody" and Game.enemy.next_move == "nimtie_d":
		insertStatusesFunction([TileStatus.CURSED], 0.65, [1.0],  func(): return [Letters.get_random_letter(tile_board.get_letter_census())], 2, [1, 3])
		
