extends Control

func _ready() -> void:
	$PlayButton.pressed.connect(_on_play_pressed)
	$RandomButton.pressed.connect(_on_random_pressed)

func _on_random_pressed() -> void:
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://random_menu.tscn")

func _on_play_pressed() -> void:
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://game.tscn")
