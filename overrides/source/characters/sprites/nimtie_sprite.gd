@tool
extends CharacterSprite

var damage_sound_1 = load("res://mods/nimtie_mod/sounds/e.wav")

func play_sound(sound_data: Variant, pitch_scale: float = -1.0, volume: = 1.0, bus: = "Sound") -> AudioManagerSingleton.SoundPlayback:
	if sound_data == Sounds.LEXICOGRAPHER.FLINCH:
		return super.play_sound(damage_sound_1, 1.5, 2.2)
	elif sound_data == Sounds.CHARACTER.BLOCK:
		return super.play_sound(Sounds.CHARACTER.BLOCK)
	elif sound_data == Sounds.CHARACTER.HURT:
		return super.play_sound(Sounds.CHARACTER.HURT, -1.0, 0.5)
	elif sound_data == Sounds.CHARACTER.ATTACK:
		return super.play_sound(Sounds.CHARACTER.ATTACK)
	else:
		return null
	
