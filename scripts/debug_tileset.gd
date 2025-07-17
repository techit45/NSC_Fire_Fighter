extends Node2D

func _ready():
	print("=== DEBUG TILESET TEST ===")
	
	# Create a simple TileMap
	var tilemap = TileMap.new()
	add_child(tilemap)
	
	# Load the TileSet
	var tileset = load("res://resources/game_tileset.tres")
	print("TileSet loaded: ", tileset)
	
	if tileset:
		tilemap.tile_set = tileset
		print("TileSet assigned to TileMap")
		print("TileSet tile_size: ", tileset.tile_size)
		
		# Get the atlas source
		var atlas_source = tileset.get_source(0)
		if atlas_source:
			print("Atlas source found: ", atlas_source)
			print("Texture: ", atlas_source.texture)
			print("Texture region size: ", atlas_source.texture_region_size)
			
			# Load texture directly to check
			var texture = load("res://assets/spr_tileset_sunnysideworld_16px.png")
			print("Direct texture load: ", texture)
			if texture:
				print("Texture size: ", texture.get_size())
			
			# Place tiles one by one with debug info
			print("Placing tiles...")
			tilemap.set_cell(0, Vector2i(0, 0), 0, Vector2i(0, 0))  # GRASS
			print("Placed GRASS at (0,0)")
			
			tilemap.set_cell(0, Vector2i(1, 0), 0, Vector2i(1, 0))  # CONCRETE_FLOOR
			print("Placed CONCRETE_FLOOR at (1,0)")
			
			tilemap.set_cell(0, Vector2i(2, 0), 0, Vector2i(2, 0))  # CONCRETE_WALL
			print("Placed CONCRETE_WALL at (2,0)")
			
			tilemap.set_cell(0, Vector2i(3, 0), 0, Vector2i(3, 0))  # FIRE_DAMAGE
			print("Placed FIRE_DAMAGE at (3,0)")
			
			# Place a bigger grid
			for x in range(10):
				for y in range(10):
					var tile_coord = Vector2i(x % 4, 0)
					tilemap.set_cell(0, Vector2i(x, y + 2), 0, tile_coord)
			
			print("Placed 10x10 grid of tiles")
			
			# Add visual markers
			create_visual_markers()
		else:
			print("ERROR: No atlas source found!")
	else:
		print("ERROR: TileSet not loaded!")

func create_visual_markers():
	print("Creating visual markers...")
	for i in range(10):
		var marker = ColorRect.new()
		marker.size = Vector2(8, 8)
		marker.position = Vector2(i * 16 + 4, 4)
		marker.color = Color.RED
		add_child(marker)
		
		var marker2 = ColorRect.new()
		marker2.size = Vector2(8, 8)
		marker2.position = Vector2(i * 16 + 4, 32 + 4)
		marker2.color = Color.BLUE
		add_child(marker2)
	
	print("Visual markers created")