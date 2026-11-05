extends Node2D

@onready var restart_ui: Control = $UI/RestartUI
@onready var reset_button: TextureButton = $UI/RestartUI/ResetButton
@onready var redo_button: TextureButton = $UI/RestartUI/RedoButton
@onready var player: GridPlayer = $CharacterBody2D
@onready var enemy: Enemy = $Enemy
@onready var tilemap: TileMapLayer = $TileMapLayer
@onready var rock_manager: RockManager = $RockManager


func _ready() -> void:
	restart_ui.hide()
	reset_button.pressed.connect(_on_reset_pressed)
	redo_button.pressed.connect(_on_redo_pressed)
	player.died.connect(_show_end)
	enemy.died.connect(_show_end)

	# children have already run their _ready() by now, so it's safe to overwrite their state here.
	if SaveManager.load_on_start:
		SaveManager.load_on_start = false
		_apply_save(SaveManager.read())


func _unhandled_input(event: InputEvent) -> void:
	# temp hotkeys changed! (from f5 to save and f9 to load)
	if Input.is_action_just_pressed("save"):
		save_game()
	elif Input.is_action_just_pressed("load"):
		load_game()


func _show_end() -> void:
	if restart_ui.visible:
		return
	restart_ui.show()
	var tree := get_tree()
	if tree:
		tree.paused = true


func _on_reset_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_redo_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")


# save n load stuff

func save_game() -> bool:
	# dont save a finished run or a player mid-move, since that would just be uh. yeah. bad.
	if restart_ui.visible or player.is_dead or player.is_moving:
		return false
	var ok := SaveManager.write(_collect_save())
	if ok:
		print("Game saved")
	return ok


func load_game() -> void:
	if not SaveManager.has_save():
		return
	SaveManager.load_on_start = true
	get_tree().paused = false
	get_tree().reload_current_scene()


func _collect_save() -> Dictionary:
	# The tilemap holds the dirt AND the rocks, so saving it captures
	# everything the player has dug up or pushed.
	var tiles := []
	for cell in tilemap.get_used_cells():
		tiles.append([
			cell,
			tilemap.get_cell_source_id(cell),
			tilemap.get_cell_atlas_coords(cell),
			tilemap.get_cell_alternative_tile(cell),
		])

	# The enemy frees itself shortly after dying, so check validity first.
	var enemy_alive := is_instance_valid(enemy) and not enemy.is_dead

	return {
		"tiles": tiles,
		"player": {
			"cell": player.current_grid_pos,
			"facing_frame": player.sprite.frame,
		},
		"enemy": {
			"alive": enemy_alive,
			"cell": enemy.cell if enemy_alive else Vector2i.ZERO,
		},
		"rocks": rock_manager.get_save_data(),
	}


func _apply_save(data: Dictionary) -> void:
	if data.is_empty():
		push_warning("No valid save found, starting a new game")
		return

	tilemap.clear()
	for t in data["tiles"]:
		tilemap.set_cell(t[0], t[1], t[2], t[3])

	var p: Dictionary = data["player"]
	player.current_grid_pos = p["cell"]
	player.position = player.grid_to_world(player.current_grid_pos)
	player.sprite.frame = p["facing_frame"]

	var e: Dictionary = data["enemy"]
	if e["alive"]:
		enemy.cell = e["cell"]
		enemy.position = enemy.grid_to_world(enemy.cell)
	else:
		enemy.is_dead = true  # stops its logic and makes die() a no-op
		enemy.queue_free()

	rock_manager.load_save_data(data["rocks"])
