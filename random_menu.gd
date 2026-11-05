extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)
	$SeedInput.text_submitted.connect(_on_seed_input_submitted)

func _on_seed_input_submitted(seed: String) -> void:
	print("Submitted: ", seed)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
