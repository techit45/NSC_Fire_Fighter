extends Node2D
class_name TileMapManager

# TileMap layer organization
@export var floor_layer: TileMap
@export var wall_layer: TileMap
@export var interactive_layer: TileMap
@export var damage_layer: TileMap
@export var trigger_layer: TileMap

# Collision layers (following specification)
enum CollisionLayers {
	FLOOR = 1,       # Layer 0: Walkable surfaces (no collision)
	WALL = 2,        # Layer 1: Collision surfaces (full collision)
	INTERACTIVE = 4, # Layer 2: Interactive objects (custom collision)
	DAMAGE = 8,      # Layer 3: Damage zones (area detection)
	TRIGGER = 16     # Layer 4: Trigger areas (area detection)
}

# Tile type definitions
enum TileTypes {
	CONCRETE_FLOOR,
	WOOD_FLOOR,
	CARPET,
	GRASS,
	CONCRETE_WALL,
	BRICK_WALL,
	WOOD_WALL,
	DOOR,
	FURNITURE,
	WINDOW,
	FIRE_DAMAGE,
	SMOKE_DAMAGE,
	DEBRIS,
	SCENE_TRANSITION,
	MISSION_TRIGGER,
	STORY_TRIGGER
}

# TileSet resource reference
@export var game_tileset: TileSet

func _ready():
	setup_tilemap_layers()
	configure_collision_layers()

func setup_tilemap_layers():
	# Find existing TileMap layers first
	if not floor_layer:
		floor_layer = get_node_or_null("FloorLayer")
	if not wall_layer:
		wall_layer = get_node_or_null("WallLayer")
	
	# Create TileMap layers if they don't exist
	if not floor_layer:
		floor_layer = create_tilemap_layer("FloorLayer", 0)
	if not wall_layer:
		wall_layer = create_tilemap_layer("WallLayer", 1)
	if not interactive_layer:
		interactive_layer = create_tilemap_layer("InteractiveLayer", 2)
	if not damage_layer:
		damage_layer = create_tilemap_layer("DamageLayer", 3)
	if not trigger_layer:
		trigger_layer = create_tilemap_layer("TriggerLayer", 4)
	
	# Assign TileSet to all layers
	if game_tileset:
		floor_layer.tile_set = game_tileset
		wall_layer.tile_set = game_tileset
		interactive_layer.tile_set = game_tileset
		damage_layer.tile_set = game_tileset
		trigger_layer.tile_set = game_tileset

func create_tilemap_layer(layer_name: String, layer_z_index: int) -> TileMap:
	var tilemap = TileMap.new()
	tilemap.name = layer_name
	tilemap.z_index = layer_z_index
	add_child(tilemap)
	return tilemap

func configure_collision_layers():
	# In Godot 4.x, collision is handled through the TileSet's physics layers
	# The collision properties are set in the TileSet resource itself
	# Individual TileMaps inherit collision from their tiles
	print("TileMap collision configured through TileSet physics layers")

# Utility functions for tile placement
func place_floor_tile(pos: Vector2i, tile_type: TileTypes):
	var source_id = get_source_id_for_tile_type(tile_type)
	var atlas_coords = get_atlas_coords_for_tile_type(tile_type)
	floor_layer.set_cell(0, pos, source_id, atlas_coords)

func place_wall_tile(pos: Vector2i, tile_type: TileTypes):
	var source_id = get_source_id_for_tile_type(tile_type)
	var atlas_coords = get_atlas_coords_for_tile_type(tile_type)
	wall_layer.set_cell(0, pos, source_id, atlas_coords)

func place_interactive_tile(pos: Vector2i, tile_type: TileTypes):
	var source_id = get_source_id_for_tile_type(tile_type)
	var atlas_coords = get_atlas_coords_for_tile_type(tile_type)
	interactive_layer.set_cell(0, pos, source_id, atlas_coords)

func place_damage_tile(pos: Vector2i, tile_type: TileTypes):
	var source_id = get_source_id_for_tile_type(tile_type)
	var atlas_coords = get_atlas_coords_for_tile_type(tile_type)
	damage_layer.set_cell(0, pos, source_id, atlas_coords)

func place_trigger_tile(pos: Vector2i, tile_type: TileTypes):
	var source_id = get_source_id_for_tile_type(tile_type)
	var atlas_coords = get_atlas_coords_for_tile_type(tile_type)
	trigger_layer.set_cell(0, pos, source_id, atlas_coords)

func get_source_id_for_tile_type(_tile_type: TileTypes) -> int:
	# All tiles are in the same atlas source for now
	return 0

func get_atlas_coords_for_tile_type(tile_type: TileTypes) -> Vector2i:
	match tile_type:
		# Floor tiles - Room Builder coordinates
		TileTypes.GRASS:
			return Vector2i(5, 0)  # Grass tile
		TileTypes.CONCRETE_FLOOR:
			return Vector2i(4, 0)  # Concrete floor
		TileTypes.WOOD_FLOOR:
			return Vector2i(0, 0)  # Wood floor
		TileTypes.CARPET:
			return Vector2i(2, 0)  # Carpet floor
		# Wall tiles
		TileTypes.CONCRETE_WALL:
			return Vector2i(1, 1)  # Wall middle
		TileTypes.BRICK_WALL:
			return Vector2i(0, 1)  # Wall top
		TileTypes.WOOD_WALL:
			return Vector2i(2, 1)  # Wall bottom
		# Damage tiles
		TileTypes.FIRE_DAMAGE:
			return Vector2i(3, 0)  # Tile floor (for damage effect)
		TileTypes.SMOKE_DAMAGE:
			return Vector2i(1, 0)  # Stone floor (for smoke effect)
		TileTypes.DEBRIS:
			return Vector2i(1, 0)  # Stone floor (for debris)
		# Interactive tiles - furniture
		TileTypes.DOOR:
			return Vector2i(0, 2)  # Door tile
		TileTypes.FURNITURE:
			return Vector2i(2, 2)  # Table furniture
		TileTypes.WINDOW:
			return Vector2i(1, 2)  # Window tile
		# Trigger tiles
		TileTypes.SCENE_TRANSITION, TileTypes.MISSION_TRIGGER, TileTypes.STORY_TRIGGER:
			return Vector2i(5, 0)  # Grass tile for triggers
		_:
			return Vector2i(0, 0)

# Get tile information
func get_tile_data(layer: TileMap, pos: Vector2i) -> TileData:
	var source_id = layer.get_cell_source_id(0, pos)
	var atlas_coords = layer.get_cell_atlas_coords(0, pos)
	
	if source_id == -1:
		return null
	
	var source = layer.tile_set.get_source(source_id) as TileSetAtlasSource
	return source.get_tile_data(atlas_coords, 0)

func is_tile_walkable(layer: TileMap, pos: Vector2i) -> bool:
	var tile_data = get_tile_data(layer, pos)
	if not tile_data:
		return true
	
	var blocks_movement = tile_data.get_custom_data("blocks_movement")
	return not blocks_movement

func get_tile_type(layer: TileMap, pos: Vector2i) -> String:
	var tile_data = get_tile_data(layer, pos)
	if not tile_data:
		return ""
	
	return tile_data.get_custom_data("tile_type")

# Clear tiles
func clear_tile(layer: TileMap, pos: Vector2i):
	layer.set_cell(0, pos, -1)

func clear_area(layer: TileMap, rect: Rect2i):
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			clear_tile(layer, Vector2i(x, y))

# Utility function to convert world position to tile coordinates
func world_to_tile(world_pos: Vector2) -> Vector2i:
	return Vector2i(world_pos / 16)  # Using 16x16 tile size

func tile_to_world(tile_pos: Vector2i) -> Vector2:
	return Vector2(tile_pos * 16) + Vector2(8, 8)  # Center of tile
