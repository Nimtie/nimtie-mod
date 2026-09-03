extends "res://mods/framework/overrides_old/tile_board.gd"
var dooming_rows = []
var deflation_sound = load("res://mods/nimtie_mod/sounds/balloon_deflate.wav")
var CoordTarget = load("res://source/effects/coord_target.tscn")	
	
func turn_end(reroll: = false, end_of_battle: = false):
	await super(reroll, end_of_battle)
	if Game.player.id == "nimtie" and Game.enemy.get_unit_name() != "Nobody":
		var cols = Game.tile_board.num_columns
		var rows = Game.tile_board.num_rows
		if Game.enemy.get_unit_name() != "Nobody" and [rows, cols] == [5,5]:
			AudioManager.play_sound(deflation_sound, 1.0, 0.5)
			
		var targets = Game.tile_board.get_targeted_coords()
		if targets.size() > 0:
			for target in targets:
				target.clear()
			
		await Game.tile_board.set_size(4,4, null, null, false, 1.0, TileBoard.ExpandMode.TOP_RIGHT)
		
		for target in targets:
			var coord = Game.tile_board.get_status_coord(target)
			var coord_target = CoordTarget.instantiate()
			Game.tile_board.set_coord_status(coord, coord_target)
		
		if Game.enemy.get_unit_name() != "Nobody":
			Game.enemy.dooming_columns.clear()
			dooming_rows.clear()
			
func calculate_crit_bonus(word_lists: Array[WordList]) -> float:
	var player_crit_chance: Dictionary = Game.player.get_crit_chance()
	if player_crit_chance.BONUS_PER_LETTER <= 0.0:
		return 0.0

	var total_crit_bonus: = 0.0

	for word_list in word_lists:
		var bonus_length = (word_list.maximum_length - player_crit_chance.MINIMUM_WORD_LENGTH)
		var crit_bonus: float = bonus_length * player_crit_chance.BONUS_PER_LETTER
		crit_bonus = maxf(0.0, crit_bonus)
		total_crit_bonus += crit_bonus
	
	if Game.player.id == "nimtie":
		total_crit_bonus *= (11.0/15.0)
		
	return total_crit_bonus
	
func get_doomed_rows() -> Array[int]:
	var doomed_rows: Array[int] = []
	_posmod_array(dooming_rows, num_rows)
	for row in dooming_rows:
		if row not in doomed_rows:
			doomed_rows.append(row)
	return doomed_rows

func set_doomed_rows(doomed_rows):
	dooming_rows = doomed_rows

func clear_doomed_rows():
	dooming_rows.clear()

func fill_board(instant: = false, ignore_lock: = false):
	if prevent_filling:
		return


	if restock_locked and ( not instant and not ignore_lock):
		return

	prepare_queue()
	fill_queue()

	var doomed_columns: = get_doomed_columns()
	var doomed_rows: = get_doomed_rows()
	
	
	var immediate_queued_tiles = queue.get_tiles(true)
	rng.fill.shuffle(immediate_queued_tiles)
	for queued_tile in immediate_queued_tiles:
		if "as_save" in queued_tile:
			continue

		var coord: = queue.get_queued_tile_coord(queued_tile)
		var needed_tiles = get_column_needed_tiles(coord.x)
		var is_doomed = (needed_tiles - coord.y - 1) in doomed_rows
		if "type" not in queued_tile:
			if coord.x in doomed_columns or is_doomed:
				var defense_chance: = float(Game.balance.defense_in_bag) / float(Game.balance.defense_in_bag + Game.balance.damage_in_bag)
				if Game.random.randf() <= defense_chance:
					queued_tile.type = TileType.DEFENSE
				else:
					queued_tile.type = TileType.DAMAGE
			else:
				queued_tile.type = pop_from_bag()

		var has_non_shared_status: bool = false
		if "statuses" in queued_tile:
			for status in queued_tile.statuses:
				if Status.status_is_exclusive(status):
					has_non_shared_status = true

		if coord.x in doomed_columns or is_doomed or main.tutorial.active:
			continue

		if ( not has_non_shared_status or "can_crit" in queued_tile) and not Game.player.crits_are_wildcards() and roll_crit():
			queued_tile.get_or_add("statuses", []).append(TileStatus.CRIT)
			AchievementManager.rolled_crit()

	queue.clear_targeted_coords()

	is_restocking = true
	update_state()

	var shuffled_indices = range(num_columns)
	shuffled_indices.shuffle()
	var last_index = shuffled_indices[-1]

	var columns_to_fill = {}
	for x in shuffled_indices:
		var needed_tiles: = get_column_needed_tiles(x)
		if needed_tiles > 0:
			columns_to_fill[x] = needed_tiles
			filling_columns += 1

	for x in columns_to_fill:
		var needed_tiles = columns_to_fill[x]
		_fill_column(x, needed_tiles, instant)
		if not instant and x != last_index:
			await Game.timeout(0.16)

	if filling_columns > 0:
		await all_columns_filled

	await wait_for_idle_tiles()
	is_restocking = false

	update_state()
	tiles_changed.emit()
