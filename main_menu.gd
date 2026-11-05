extends Control

func _ready() -> void:
	$PlayButton.pressed.connect(_on_play_pressed)
	$RandomButton.pressed.connect(_on_random_pressed)

func _on_random_pressed() -> void:
	get_tree().change_scene_to_file("res://random_menu.tscn")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
