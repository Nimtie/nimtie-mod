extends Spell

func product(array):
	var results = [[]]
	for i in range(len(array)):
		var temp = []
		for res in results:
			for element in array[i]:
				temp.append(res + [element])
		results = temp
	return results

func _use():
	if not can_submit():
		_end_use()
		return

	#["w","r"]
	Game.screenshake(2, 0.16)
	AudioManager.play_sound(Sounds.SPELLS.BOX_SHUFFLE)
	
	await word_builder.submit_word()
	
	_post_use()
	
func can_submit():
	var words: WordList = word_builder.get_words()
	if words.sub_lists.size() == 1:
		var word = words.invalid_word
		var uwuified_word = ""
		var arr = []
		var res = []
		var numberofI = 0
		
		for w in word:
			if w == "w" or w == "r":
				arr.append(["w", "r"])
				res = product(arr)
		
		for i in range(res.size()):
			numberofI = 0
			uwuified_word = ""
			for j in range(len(word)):
				if word[j] == "w" or word[j] == "r":
					uwuified_word += res[i][numberofI]
					numberofI += 1
				else:
					uwuified_word += word[j]
			print(uwuified_word)
			if WordUtility.dictionary.is_word(uwuified_word):
				break
		
		if WordUtility.dictionary.is_word(uwuified_word):
			words.all_valid = true
			words.words.append(word)
			return word_builder.can_submit()
		else:
			return false
	return false

func is_usable():
	return super.is_usable() and not word_builder.is_submitting and can_submit()
	

	
