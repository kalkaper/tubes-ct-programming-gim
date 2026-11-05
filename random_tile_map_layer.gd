extends TileMapLayer

func shuffle_seeded(array: Array, rng: RandomNumberGenerator) -> void:
	for i in range(array.size() - 1, 0, -1):
		var j = rng.randi_range(0, i)
		# Swap elements
		var temp = array[i]
		array[i] = array[j]
		array[j] = temp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print_tree_pretty()
	var tiles = Array(range(0, 14 * 8))
	var rng = RandomNumberGenerator.new()
	rng.seed = GameState.current_seed
	shuffle_seeded(tiles, rng)
	for i in range(tiles.size()):
		var x = round(tiles[i] / 8)
		var y = tiles[i] % 8
		if i < 14 and tiles[i] != 13 and tiles[i] != 63:
			# turn this to rock
			set_cell(Vector2i(x + 1, y + 1), 1, Vector2i(4, 2))
		else:
			set_cell(Vector2i(x + 1, y + 1), 0, Vector2i(randi_range(19, 20), 5))
	#print(tiles)
	#print(seed)
