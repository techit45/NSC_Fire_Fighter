extends Node2D

var player = null
var tilemap_manager = null

func _ready():
	print("=== FIRE STATION SCENE STARTING ===")
	print("Fire Station scene initialized")
	
	# Get player reference safely
	player = get_node_or_null("Player")
	if player:
		print("Player found in fire station")
	else:
		print("Warning: Player not found in fire station scene")
	
	# Get TileMapManager but DON'T set up tiles automatically
	tilemap_manager = get_node_or_null("TileMapManager")
	print("TileMapManager search result: ", tilemap_manager)
	
	if tilemap_manager:
		print("Found TileMapManager - tiles should be manually drawn in editor")
		# call_deferred("setup_station_tiles")  # DISABLED: Let user draw tiles manually
	else:
		print("ERROR: TileMapManager not found!")
	
	# All mission transitions are now handled by the Fire Truck object
	print("Fire station ready with all interaction points")
	print("=== FIRE STATION SCENE READY ===")

func setup_station_tiles():
	print("Setting up Fire Station TileMap layout...")
	
	if not tilemap_manager:
		print("TileMapManager not found!")
		return
	
	# Force clear all existing tiles first
	clear_all_tiles()
	
	# Wait a frame then create new layout
	await get_tree().process_frame
	
	# Create the main floor area
	create_station_floor()
	
	# Create walls around the perimeter  
	create_station_walls()
	
	# Create interactive areas for equipment placement
	create_interactive_areas()
	
	print("Fire Station TileMap setup complete!")

func clear_all_tiles():
	print("Clearing all existing tiles...")
	
	# Clear large areas on all layers
	var clear_rect = Rect2i(-20, -10, 80, 60)
	
	if tilemap_manager.floor_layer:
		tilemap_manager.clear_area(tilemap_manager.floor_layer, clear_rect)
	if tilemap_manager.wall_layer:
		tilemap_manager.clear_area(tilemap_manager.wall_layer, clear_rect)
	if tilemap_manager.interactive_layer:
		tilemap_manager.clear_area(tilemap_manager.interactive_layer, clear_rect)

func create_station_floor():
	print("Creating detailed station floor...")
	print("TileMapManager: ", tilemap_manager)
	print("Floor layer: ", tilemap_manager.floor_layer if tilemap_manager else "null")
	
	# Extended floor area for a larger, more detailed station
	var floor_start = Vector2i(8, 12)    # Building interior
	var floor_end = Vector2i(38, 26)     # Building interior
	
	print("Placing floor tiles from ", floor_start, " to ", floor_end)
	
	# Main concrete floor for building interior
	var tiles_placed = 0
	for x in range(floor_start.x, floor_end.x + 1):
		for y in range(floor_start.y, floor_end.y + 1):
			tilemap_manager.place_floor_tile(Vector2i(x, y), TileMapManager.TileTypes.CONCRETE_FLOOR)
			tiles_placed += 1
	
	print("Placed ", tiles_placed, " floor tiles")
	
	# Special grass areas outside the building (landscaping)
	create_landscaping_areas()

func create_station_walls():
	print("Creating detailed station walls...")
	
	# Main building outer walls
	var building_start = Vector2i(8, 12)   # Main building area
	var building_end = Vector2i(38, 26)
	
	# Outer perimeter walls
	create_building_perimeter(building_start, building_end)
	
	# Interior room divisions
	create_interior_walls()
	
	# Garage area walls
	create_garage_walls()
	
	# Office area walls
	create_office_walls()

func create_building_perimeter(start: Vector2i, end: Vector2i):
	print("Creating building perimeter from ", start, " to ", end)
	var walls_placed = 0
	
	# Top wall
	for x in range(start.x, end.x + 1):
		tilemap_manager.place_wall_tile(Vector2i(x, start.y), TileMapManager.TileTypes.CONCRETE_WALL)
		walls_placed += 1
	
	# Bottom wall with main entrance
	for x in range(start.x, end.x + 1):
		if x < 22 or x > 25:  # Skip entrance area
			tilemap_manager.place_wall_tile(Vector2i(x, end.y), TileMapManager.TileTypes.CONCRETE_WALL)
			walls_placed += 1
	
	# Left wall
	for y in range(start.y, end.y + 1):
		tilemap_manager.place_wall_tile(Vector2i(start.x, y), TileMapManager.TileTypes.CONCRETE_WALL)
		walls_placed += 1
	
	# Right wall
	for y in range(start.y, end.y + 1):
		tilemap_manager.place_wall_tile(Vector2i(end.x, y), TileMapManager.TileTypes.CONCRETE_WALL)
		walls_placed += 1
	
	print("Placed ", walls_placed, " wall tiles")

func create_interior_walls():
	# Vertical divider separating garage from office area
	for y in range(14, 24):
		tilemap_manager.place_wall_tile(Vector2i(25, y), TileMapManager.TileTypes.CONCRETE_WALL)
	
	# Horizontal divider creating rooms
	for x in range(26, 37):
		tilemap_manager.place_wall_tile(Vector2i(x, 18), TileMapManager.TileTypes.CONCRETE_WALL)
	
	# Doorways in interior walls
	tilemap_manager.clear_tile(tilemap_manager.wall_layer, Vector2i(25, 20))  # Garage to office door
	tilemap_manager.clear_tile(tilemap_manager.wall_layer, Vector2i(30, 18))  # Room door

func create_garage_walls():
	# Garage bay opening (left side of building)
	for x in range(10, 18):
		tilemap_manager.clear_tile(tilemap_manager.wall_layer, Vector2i(x, 12))  # Garage door opening

func create_office_walls():
	# Small office rooms in the right section
	# Equipment room walls
	for x in range(32, 36):
		tilemap_manager.place_wall_tile(Vector2i(x, 21), TileMapManager.TileTypes.CONCRETE_WALL)
	for y in range(19, 23):
		tilemap_manager.place_wall_tile(Vector2i(32, y), TileMapManager.TileTypes.CONCRETE_WALL)
	
	# Equipment room door
	tilemap_manager.clear_tile(tilemap_manager.wall_layer, Vector2i(33, 21))

func create_interactive_areas():
	print("Creating detailed interactive areas...")
	
	# Fire pole in garage area
	var pole_x = 15  # Center of garage
	var pole_y = 16
	tilemap_manager.place_interactive_tile(Vector2i(pole_x, pole_y), TileMapManager.TileTypes.FURNITURE)
	
	# Equipment storage areas
	create_equipment_areas()
	
	# Office furniture
	create_office_furniture()
	
	# Parking spots for fire truck
	create_parking_areas()

func create_equipment_areas():
	# Equipment storage along garage walls
	for x in range(10, 14):
		tilemap_manager.place_interactive_tile(Vector2i(x, 24), TileMapManager.TileTypes.FURNITURE)  # Storage lockers
	
	# Equipment table area (matches existing NPC positions)
	tilemap_manager.place_interactive_tile(Vector2i(12, 20), TileMapManager.TileTypes.FURNITURE)  # Equipment table

func create_office_furniture():
	# Chief's desk area
	for x in range(28, 30):
		for y in range(15, 17):
			tilemap_manager.place_interactive_tile(Vector2i(x, y), TileMapManager.TileTypes.FURNITURE)
	
	# Computer terminal area
	tilemap_manager.place_interactive_tile(Vector2i(25, 15), TileMapManager.TileTypes.FURNITURE)  # Computer desk
	
	# Map board area
	tilemap_manager.place_interactive_tile(Vector2i(15, 12), TileMapManager.TileTypes.FURNITURE)  # Map board wall mount

func create_parking_areas():
	# Fire truck parking area in garage
	for x in range(17, 23):
		for y in range(22, 25):
			tilemap_manager.place_interactive_tile(Vector2i(x, y), TileMapManager.TileTypes.FURNITURE)  # Parking area markers

func create_landscaping_areas():
	print("Adding landscaping...")
	
	# Grass areas around the building exterior
	# Front lawn area
	for x in range(4, 42):
		for y in range(4, 8):
			tilemap_manager.place_floor_tile(Vector2i(x, y), TileMapManager.TileTypes.GRASS)
	
	# Side grass areas
	for x in range(4, 8):
		for y in range(8, 28):
			tilemap_manager.place_floor_tile(Vector2i(x, y), TileMapManager.TileTypes.GRASS)
	
	for x in range(39, 42):
		for y in range(8, 28):
			tilemap_manager.place_floor_tile(Vector2i(x, y), TileMapManager.TileTypes.GRASS)
	
	# Back area
	for x in range(4, 42):
		for y in range(28, 32):
			tilemap_manager.place_floor_tile(Vector2i(x, y), TileMapManager.TileTypes.GRASS)
