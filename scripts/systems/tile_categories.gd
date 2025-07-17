extends Resource
class_name TileCategories

# Tile category definitions with properties
enum Category {
	WALKABLE_FLOOR,
	COLLISION_WALL,
	INTERACTIVE_OBJECT,
	DAMAGE_ZONE,
	TRIGGER_AREA
}

# Floor tile definitions (Category: WALKABLE_FLOOR)
static var FLOOR_TILES = {
	"CONCRETE_FLOOR": {
		"category": Category.WALKABLE_FLOOR,
		"collision_layer": 1,
		"blocks_movement": false,
		"fire_resistance": 0.8,
		"description": "Standard concrete flooring - fire resistant"
	},
	"WOOD_FLOOR": {
		"category": Category.WALKABLE_FLOOR,
		"collision_layer": 1,
		"blocks_movement": false,
		"fire_resistance": 0.3,
		"description": "Wooden flooring - flammable"
	},
	"CARPET": {
		"category": Category.WALKABLE_FLOOR,
		"collision_layer": 1,
		"blocks_movement": false,
		"fire_resistance": 0.1,
		"description": "Carpeted floor - highly flammable"
	},
	"GRASS": {
		"category": Category.WALKABLE_FLOOR,
		"collision_layer": 1,
		"blocks_movement": false,
		"fire_resistance": 0.2,
		"description": "Grass surface - can spread fire"
	}
}

# Wall tile definitions (Category: COLLISION_WALL)
static var WALL_TILES = {
	"CONCRETE_WALL": {
		"category": Category.COLLISION_WALL,
		"collision_layer": 2,
		"blocks_movement": true,
		"fire_resistance": 0.9,
		"description": "Concrete wall - high fire resistance"
	},
	"BRICK_WALL": {
		"category": Category.COLLISION_WALL,
		"collision_layer": 2,
		"blocks_movement": true,
		"fire_resistance": 0.7,
		"description": "Brick wall - moderate fire resistance"
	},
	"WOOD_WALL": {
		"category": Category.COLLISION_WALL,
		"collision_layer": 2,
		"blocks_movement": true,
		"fire_resistance": 0.2,
		"description": "Wooden wall - flammable"
	}
}

# Interactive object definitions (Category: INTERACTIVE_OBJECT)
static var INTERACTIVE_TILES = {
	"DOOR": {
		"category": Category.INTERACTIVE_OBJECT,
		"collision_layer": 4,
		"blocks_movement": false,
		"fire_resistance": 0.3,
		"interaction_type": "door",
		"description": "Door - can be opened/closed"
	},
	"FURNITURE": {
		"category": Category.INTERACTIVE_OBJECT,
		"collision_layer": 4,
		"blocks_movement": true,
		"fire_resistance": 0.2,
		"interaction_type": "furniture",
		"description": "Furniture - can be moved or destroyed"
	},
	"WINDOW": {
		"category": Category.INTERACTIVE_OBJECT,
		"collision_layer": 4,
		"blocks_movement": true,
		"fire_resistance": 0.1,
		"interaction_type": "window",
		"description": "Window - can be broken for escape"
	}
}

# Damage zone definitions (Category: DAMAGE_ZONE)
static var DAMAGE_TILES = {
	"FIRE_DAMAGE": {
		"category": Category.DAMAGE_ZONE,
		"collision_layer": 8,
		"blocks_movement": false,
		"damage_per_second": 20,
		"damage_type": "fire",
		"description": "Fire damage zone - deals fire damage"
	},
	"SMOKE_DAMAGE": {
		"category": Category.DAMAGE_ZONE,
		"collision_layer": 8,
		"blocks_movement": false,
		"damage_per_second": 5,
		"damage_type": "smoke",
		"description": "Smoke damage zone - deals suffocation damage"
	},
	"DEBRIS": {
		"category": Category.DAMAGE_ZONE,
		"collision_layer": 8,
		"blocks_movement": true,
		"damage_per_second": 10,
		"damage_type": "physical",
		"description": "Debris - blocks movement and can cause damage"
	}
}

# Trigger area definitions (Category: TRIGGER_AREA)
static var TRIGGER_TILES = {
	"SCENE_TRANSITION": {
		"category": Category.TRIGGER_AREA,
		"collision_layer": 16,
		"blocks_movement": false,
		"trigger_type": "scene_transition",
		"description": "Scene transition trigger"
	},
	"MISSION_TRIGGER": {
		"category": Category.TRIGGER_AREA,
		"collision_layer": 16,
		"blocks_movement": false,
		"trigger_type": "mission_start",
		"description": "Mission start trigger"
	},
	"STORY_TRIGGER": {
		"category": Category.TRIGGER_AREA,
		"collision_layer": 16,
		"blocks_movement": false,
		"trigger_type": "story_event",
		"description": "Story event trigger"
	}
}

# Utility functions
static func get_tile_properties(tile_type: String) -> Dictionary:
	if FLOOR_TILES.has(tile_type):
		return FLOOR_TILES[tile_type]
	elif WALL_TILES.has(tile_type):
		return WALL_TILES[tile_type]
	elif INTERACTIVE_TILES.has(tile_type):
		return INTERACTIVE_TILES[tile_type]
	elif DAMAGE_TILES.has(tile_type):
		return DAMAGE_TILES[tile_type]
	elif TRIGGER_TILES.has(tile_type):
		return TRIGGER_TILES[tile_type]
	else:
		return {}

static func is_tile_walkable(tile_type: String) -> bool:
	var properties = get_tile_properties(tile_type)
	return not properties.get("blocks_movement", false)

static func get_tile_fire_resistance(tile_type: String) -> float:
	var properties = get_tile_properties(tile_type)
	return properties.get("fire_resistance", 0.5)

static func get_tile_damage(tile_type: String) -> int:
	var properties = get_tile_properties(tile_type)
	return properties.get("damage_per_second", 0)

static func get_tile_category(tile_type: String) -> Category:
	var properties = get_tile_properties(tile_type)
	return properties.get("category", Category.WALKABLE_FLOOR)

static func get_collision_layer_for_category(category: Category) -> int:
	match category:
		Category.WALKABLE_FLOOR:
			return 1
		Category.COLLISION_WALL:
			return 2
		Category.INTERACTIVE_OBJECT:
			return 4
		Category.DAMAGE_ZONE:
			return 8
		Category.TRIGGER_AREA:
			return 16
		_:
			return 1