extends TileMapLayer

func shuffle_seeded(array: Array, rng: RandomNumberGenerator) -> void:
	for i in range(array.size() - 1, 0, -1):
		var j = rng.randi_range(0, i)
		# swap elements
		var temp = array[i]
		array[i] = array[j]
		array[j] = temp

func _ready() -> void:
	var tiles = Array(range(0, 14 * 8))
	var rng = RandomNumberGenerator.new()
	rng.seed = GameState.current_seed
	# shuffle the tiles
	shuffle_seeded(tiles, rng)
	# generate the tiles according to the seed
	for i in range(tiles.size()):
		var x = round(tiles[i] / 8)
		var y = tiles[i] % 8
		if i < 14 and tiles[i] != 13 and tiles[i] != 63:
			# turn this to rock
			set_cell(Vector2i(x + 1, y + 1), 1, Vector2i(4, 2))
		else:
			# turn this to dirt
			# player tile and enemy tile is always dirt
			set_cell(Vector2i(x + 1, y + 1), 0, Vector2i(randi_range(19, 20), 5))
