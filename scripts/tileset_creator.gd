extends Node2D

func _ready():
	print("=== CREATING TILESET IN CODE ===")
	
	# Create TileSet in code
	var tileset = TileSet.new()
	tileset.tile_size = Vector2i(16, 16)
	
	# Load the texture
	var texture = load("res://assets/spr_tileset_sunnysideworld_16px.png")
	print("Texture loaded: ", texture)
	
	# Display the texture directly as a sprite
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.position = Vector2(100, 100)
	sprite.scale = Vector2(0.5, 0.5)  # Scale down to see it better
	add_child(sprite)
	print("Added sprite to show texture")
	
	# Create atlas source
	var atlas_source = TileSetAtlasSource.new()
	atlas_source.texture = texture
	atlas_source.texture_region_size = Vector2i(16, 16)
	
	print("Setting texture_region_size to: ", atlas_source.texture_region_size)
	
	# Add tiles to the atlas - using coordinates that should have visible tiles
	atlas_source.create_tile(Vector2i(0, 0))  # Top-left tile
	atlas_source.create_tile(Vector2i(1, 0))  # Next tile
	atlas_source.create_tile(Vector2i(2, 0))  # Next tile
	atlas_source.create_tile(Vector2i(3, 0))  # Next tile
	atlas_source.create_tile(Vector2i(4, 0))  # Next tile
	atlas_source.create_tile(Vector2i(5, 0))  # Next tile
	atlas_source.create_tile(Vector2i(0, 1))  # Row 2
	atlas_source.create_tile(Vector2i(1, 1))  # Row 2
	atlas_source.create_tile(Vector2i(2, 1))  # Row 2
	atlas_source.create_tile(Vector2i(3, 1))  # Row 2
	
	print("After creating tiles, texture_region_size is: ", atlas_source.texture_region_size)
	
	# Add the atlas source to the tileset
	tileset.add_source(atlas_source, 0)
	
	print("TileSet created with atlas source")
	print("Atlas texture region size: ", atlas_source.texture_region_size)
	
	# Create TileMap and test it
	var tilemap = TileMap.new()
	tilemap.tile_set = tileset
	add_child(tilemap)
	
	print("Testing tile placement...")
	
	# Place tiles - try just one tile first
	print("Placing single test tile...")
	tilemap.set_cell(0, Vector2i(0, 0), 0, Vector2i(0, 0))
	print("Single tile placed")
	
	# Place a few more tiles manually
	tilemap.set_cell(0, Vector2i(1, 0), 0, Vector2i(1, 0))
	tilemap.set_cell(0, Vector2i(2, 0), 0, Vector2i(2, 0)) 
	tilemap.set_cell(0, Vector2i(3, 0), 0, Vector2i(3, 0))
	
	# Test with different tile coordinates
	var test_coords = [
		Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0),
		Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)
	]
	
	for i in range(test_coords.size()):
		var x = i % 5
		var y = i / 5 + 2
		tilemap.set_cell(0, Vector2i(x, y), 0, test_coords[i])
		print("Placed tile at (", x, ",", y, ") with atlas coords ", test_coords[i])
	
	print("Tiles placed!")
	
	# Add visual markers to show where tiles should be
	for x in range(5):
		for y in range(7):
			var marker = ColorRect.new()
			marker.size = Vector2(12, 12)
			marker.position = Vector2(x * 16 + 2, y * 16 + 2)
			marker.color = Color(1, 0, 0, 0.3)  # Semi-transparent red
			add_child(marker)
	
	# Save the tileset
	var save_result = ResourceSaver.save(tileset, "res://resources/game_tileset_code.tres")
	print("TileSet saved with result: ", save_result)
	
	# Test by loading the saved tileset
	await get_tree().process_frame
	var loaded_tileset = load("res://resources/game_tileset_code.tres")
	print("Loaded TileSet: ", loaded_tileset)
	if loaded_tileset:
		var loaded_source = loaded_tileset.get_source(0)
		print("Loaded source texture_region_size: ", loaded_source.texture_region_size)