extends Control

# Called when the node enters the scene tree for the first time.
func convert_to_int(string_seed: String) -> int:
	if string_seed.length() == 0:
		return randi_range(1, 1000000006)
	var prime = 101
	var mod = 1000000007
	var multiplier = prime
	var ret = 0
	for c in string_seed:
		ret += (c.unicode_at(0) - 32) * multiplier
		ret %= mod
		multiplier *= prime
		multiplier %= mod
	return ret

func _ready() -> void:
	print(get_path())
	$BackButton.pressed.connect(_on_back_pressed)
	$SeedInput.text_submitted.connect(_on_seed_input_submitted)

func _on_seed_input_submitted(string_seed: String) -> void:
	var seed = convert_to_int(string_seed)
	print("Submitted: ", string_seed)
	print("Converted: ", seed)
	GameState.current_seed = seed
	get_tree().change_scene_to_file("res://random_game.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
