extends Node

# Script to set up TileMap layout for Fire Station Scene
# This script should be run once to place all tiles

func setup_fire_station_tiles(tilemap_manager: TileMapManager):
	if not tilemap_manager:
		print("TileMapManager not found!")
		return
	
	print("Setting up Fire Station TileMap layout...")
	
	# Clear existing tiles
	clear_all_layers(tilemap_manager)
	
	# Create the main floor area (100,200 to 600,400 in world coordinates)
	# Convert to tile coordinates (divide by 16)
	create_station_floor(tilemap_manager)
	
	# Create walls around the perimeter
	create_station_walls(tilemap_manager)
	
	# Create interactive areas for equipment placement
	create_interactive_areas(tilemap_manager)
	
	print("Fire Station TileMap setup complete!")

func clear_all_layers(tilemap_manager: TileMapManager):
	print("Clearing existing tiles...")
	# Clear a large area to start fresh
	var clear_rect = Rect2i(-50, -50, 100, 100)
	tilemap_manager.clear_area(tilemap_manager.floor_layer, clear_rect)
	tilemap_manager.clear_area(tilemap_manager.wall_layer, clear_rect)
	tilemap_manager.clear_area(tilemap_manager.interactive_layer, clear_rect)

func create_station_floor(tilemap_manager: TileMapManager):
	print("Creating station floor...")
	
	# Main floor area: world 100,200 to 600,400 = tiles 6,12 to 37,25
	var floor_start = Vector2i(6, 12)   # 100/16 = 6.25, 200/16 = 12.5
	var floor_end = Vector2i(37, 25)    # 600/16 = 37.5, 400/16 = 25
	
	for x in range(floor_start.x, floor_end.x + 1):
		for y in range(floor_start.y, floor_end.y + 1):
			tilemap_manager.place_floor_tile(Vector2i(x, y), TileMapManager.TileTypes.CONCRETE_FLOOR)
	
	print("Floor tiles placed from ", floor_start, " to ", floor_end)

func create_station_walls(tilemap_manager: TileMapManager):
	print("Creating station walls...")
	
	# Outer wall perimeter based on original Polygon2D coordinates
	# Outer bounds: world 50,150 to 650,450 = tiles 3,9 to 40,28
	var outer_start = Vector2i(3, 9)
	var outer_end = Vector2i(40, 28)
	
	# Inner bounds: world 100,200 to 600,400 = tiles 6,12 to 37,25
	var inner_start = Vector2i(6, 12)
	var inner_end = Vector2i(37, 25)
	
	# Top wall (y = 9, from x = 3 to 40)
	for x in range(outer_start.x, outer_end.x + 1):
		tilemap_manager.place_wall_tile(Vector2i(x, outer_start.y), TileMapManager.TileTypes.CONCRETE_WALL)
	
	# Bottom wall (y = 28, from x = 3 to 40)
	for x in range(outer_start.x, outer_end.x + 1):
		tilemap_manager.place_wall_tile(Vector2i(x, outer_end.y), TileMapManager.TileTypes.CONCRETE_WALL)
	
	# Left wall (x = 3, from y = 9 to 28)
	for y in range(outer_start.y, outer_end.y + 1):
		tilemap_manager.place_wall_tile(Vector2i(outer_start.x, y), TileMapManager.TileTypes.CONCRETE_WALL)
	
	# Right wall (x = 40, from y = 9 to 28)
	for y in range(outer_start.y, outer_end.y + 1):
		tilemap_manager.place_wall_tile(Vector2i(outer_end.x, y), TileMapManager.TileTypes.CONCRETE_WALL)
	
	# Create entrance opening (remove some wall tiles)
	# Bottom entrance around x = 20-25
	for x in range(20, 26):
		tilemap_manager.clear_tile(tilemap_manager.wall_layer, Vector2i(x, outer_end.y))
	
	print("Wall structure created with entrance")

func create_interactive_areas(tilemap_manager: TileMapManager):
	print("Creating interactive areas...")
	
	# Fire pole area (world 180-190, 200-400 = tiles 11-12, 12-25)
	var pole_x = 11  # 180/16 ≈ 11
	for y in range(12, 26):
		tilemap_manager.place_interactive_tile(Vector2i(pole_x, y), TileMapManager.TileTypes.FURNITURE)
	
	print("Fire pole area marked as interactive")

# Function to run the setup from the scene
func _ready():
	# This will be called when the script is added to a scene
	print("Fire Station Tile Setup script ready")
	
func run_setup():
	var scene_root = get_tree().current_scene
	var tilemap_manager = scene_root.find_child("TileMapManager", true, false)
	
	if tilemap_manager:
		setup_fire_station_tiles(tilemap_manager)
	else:
		print("TileMapManager not found in scene!")