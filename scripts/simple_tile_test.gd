extends Node2D

var tilemap_manager: TileMapManager

func _ready():
	print("=== SIMPLE TILE TEST START ===")
	
	tilemap_manager = get_node("TileMapManager")
	print("TileMapManager: ", tilemap_manager)
	
	if tilemap_manager:
		print("Found TileMapManager!")
		print("Floor layer: ", tilemap_manager.floor_layer)
		print("Wall layer: ", tilemap_manager.wall_layer)
		
		call_deferred("create_simple_test")
	else:
		print("TileMapManager not found!")

func create_simple_test():
	print("Creating simple test tiles...")
	
	# Test direct TileMap placement instead of using our functions
	var floor_layer = tilemap_manager.floor_layer
	var wall_layer = tilemap_manager.wall_layer
	
	print("Direct tile placement test...")
	
	# Use ONLY the tiles we actually defined in our TileSet
	# According to our TileSet, we have: (0,0)=GRASS, (1,0)=CONCRETE_FLOOR, (2,0)=CONCRETE_WALL, (3,0)=FIRE_DAMAGE
	
	floor_layer.set_cell(0, Vector2i(0, 0), 0, Vector2i(0, 0))   # GRASS
	floor_layer.set_cell(0, Vector2i(1, 0), 0, Vector2i(1, 0))   # CONCRETE_FLOOR  
	floor_layer.set_cell(0, Vector2i(2, 0), 0, Vector2i(3, 0))   # FIRE_DAMAGE (should be visible)
	
	# Wall tiles
	wall_layer.set_cell(0, Vector2i(0, 1), 0, Vector2i(2, 0))    # CONCRETE_WALL
	wall_layer.set_cell(0, Vector2i(1, 1), 0, Vector2i(2, 0))    # CONCRETE_WALL
	wall_layer.set_cell(0, Vector2i(2, 1), 0, Vector2i(2, 0))    # CONCRETE_WALL
	
	print("Direct tiles placed!")
	
	# Also add visual markers (ColorRect) to verify positioning
	create_visual_markers()

func create_visual_markers():
	print("Creating visual markers...")
	
	var positions = [Vector2(8, 8), Vector2(24, 8), Vector2(40, 8)]
	
	for i in range(positions.size()):
		var marker = ColorRect.new()
		marker.size = Vector2(16, 16)
		marker.position = positions[i]
		marker.color = Color.RED if i == 0 else Color.GREEN if i == 1 else Color.BLUE
		add_child(marker)
		print("Added visual marker at: ", positions[i])