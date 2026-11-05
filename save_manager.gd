extends Node
# only deals with the file on disk; the game decides what goes in it.

const SAVE_PATH := "user://savegame.save"
const SAVE_VERSION := 1

# set to true right before changing/reloading to the game scene and game.gd will apply the save in its _ready().
var load_on_start := false


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func write(data: Dictionary) -> bool:
	data["version"] = SAVE_VERSION
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not open save file: %s" % error_string(FileAccess.get_open_error()))
		return false
	# var_to_str keeps Vector2i n stuff intact (since fuckass JSON can't) and stays readable
	file.store_string(var_to_str(data))
	return true


func read() -> Dictionary:
	if not has_save():
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var data = str_to_var(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY or data.get("version", 0) != SAVE_VERSION:
		push_warning("Save file missing or from an incompatible version")
		return {}
	return data
