extends "res://source/globals/letters.gd"

const LETTERS_UWU: Dictionary[String, float] = {
	"q": 1.0, 
	"j": 1.0, 
	"x": 1.0, 
	"z": 1.0, 
	"w": 5.0, 
	"k": 1.0, 
	"v": 1.0, 
	"f": 1.4, 
	"y": 1.6, 
	"b": 2.2, 
	"h": 2.3, 
	"m": 2.7, 
	"p": 3.0, 
	"g": 3.0, 
	"u": 3.3, 
	"d": 3.5, 
	"c": 4.0, 
	"l": 5.0, 
	"o": 6.0, 
	"t": 6.0, 
	"n": 7.0, 
	"r": 0.0, 
	"a": 7.5, 
	"i": 8.0, 
	"s": 8.5, 
	"e": 11.0, 
}

const LETTER_CAPS_UWU: Dictionary[String, Dictionary] = {
	"a": {soft = 2, hard = 4}, 
	"b": {soft = 2, hard = 3}, 
	"c": {soft = 2, hard = 4}, 
	"d": {soft = 2, hard = 4}, 
	"e": {soft = 3, hard = 5}, 
	"f": {soft = 2, hard = 3}, 
	"g": {soft = 3, hard = 4}, 
	"h": {soft = 2, hard = 3}, 
	"i": {soft = 2, hard = 5}, 
	"j": {soft = 2, hard = 2}, 
	"k": {soft = 2, hard = 3}, 
	"l": {soft = 2, hard = 4}, 
	"m": {soft = 2, hard = 3}, 
	"n": {soft = 3, hard = 5}, 
	"o": {soft = 2, hard = 4}, 
	"p": {soft = 2, hard = 3}, 
	"q": {soft = 2, hard = 2}, 
	"r": {soft = 0, hard = 0}, 
	"s": {soft = 4, hard = 6}, 
	"t": {soft = 3, hard = 4}, 
	"u": {soft = 2, hard = 4}, 
	"v": {soft = 2, hard = 2}, 
	"w": {soft = 4, hard = 6}, 
	"x": {soft = 2, hard = 2}, 
	"y": {soft = 2, hard = 3}, 
	"z": {soft = 2, hard = 4}, 
}

static func get_adjusted_letters(include = LETTERS_UWU, exclude = [], letter_census: LetterCensus = null):
	super()
	if is_same(include, LETTERS_UWU) and letter_census == null and exclude.is_empty():
		return LETTERS_UWU

	if exclude is not Array and exclude is not PackedStringArray:
		exclude = [exclude]

	for exclude_letter in exclude.duplicate():
		if exclude_letter in NUMPAD_CHARACTERS:
			exclude.append_array(NUMPAD_CHARACTERS[exclude_letter])

	var letters = {}
	var lenience = 0

	if Game.player.id == Globals.CHARACTERS.CHILD:
		lenience = 2

	for letter in include:
		if letter in exclude:
			continue

		if letter_census == null:
			letters[letter] = LETTERS_UWU[letter]
			continue

		var letter_amount: = letter_census.get_letter_count(letter)

		if letter_amount >= LETTER_CAPS_UWU[letter].hard + lenience:
			letters[letter] = LETTERS_UWU[letter] * 0.1
		elif letter_amount >= LETTER_CAPS_UWU[letter].soft + lenience:
			letters[letter] = LETTERS_UWU[letter] * 0.5
		else:
			letters[letter] = LETTERS_UWU[letter]


	if letters.is_empty():
		return get_adjusted_letters(include, exclude)

	return letters

static func get_random_letter(letter_census: LetterCensus = null, rng = Game.random, exclude = [], include = LETTERS_UWU) -> String:
	var letters = get_adjusted_letters(include, exclude, letter_census)
	return rng.weighted_random(letters)
