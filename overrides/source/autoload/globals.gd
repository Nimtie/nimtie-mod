extends "res://source/autoload/globals.gd"

const CHARACTERS2 = {
	NIMTIE = "nimtie"
}

const CRIT_CHANCE2 = {

	CHARACTERS2.NIMTIE: {
		MIN = 0.02, 
		MAX = 1.0, 
		DIVIDE_BY = 2.0, 
		MINIMUM_WORD_LENGTH = 4, 
		BONUS_PER_LETTER = 0.001, 
		WILDCARD = false, 
	}, 
}

## This is how I recommend overriding base game files if necessary.
## Add an override file, extend the base file,
## and use super to reuse as much base game code as possible!
func print_spell_report():
	super.print_spell_report()
	print("teehee i hijacked your spell report function")
