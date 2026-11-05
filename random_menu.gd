extends Control

func convert_to_int(string_seed: String) -> int:
	# polynomial hash of a string
	# lets go my cp (competitive programming) knowledge is used here :D
	if string_seed.length() == 0:
		# if empty, return a random number
		return randi_range(1, 3006703054056749) - 1
	var prime = 101
	var mod = 3006703054056749 
	# 52-bit prime number. source? trust me bro (nah jk it's from kactl)
	var multiplier = prime
	var ret = 0
	for c in string_seed:
		ret += (c.unicode_at(0) - 32) * multiplier
		ret %= mod
		multiplier *= prime
		multiplier %= mod
	return ret

func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)
	$SeedInput.text_submitted.connect(_on_seed_input_submitted)

func _on_seed_input_submitted(string_seed: String) -> void:
	var seed = convert_to_int(string_seed)
	GameState.current_seed = seed
	get_tree().change_scene_to_file("res://random_game.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
