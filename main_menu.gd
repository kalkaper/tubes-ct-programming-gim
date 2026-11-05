extends Control

func _ready() -> void:
	$PlayButton.pressed.connect(_on_play_pressed)

	# add button to continue if save exists
	var continue_button := get_node_or_null("ContinueButton") as BaseButton
	if continue_button:
		continue_button.disabled = not SaveManager.has_save()
		continue_button.pressed.connect(_on_continue_pressed)


func _on_play_pressed() -> void:
	SaveManager.load_on_start = false
	get_tree().change_scene_to_file("res://game.tscn")


func _on_continue_pressed() -> void:
	SaveManager.load_on_start = true
	get_tree().change_scene_to_file("res://game.tscn")
