# TileSet System Usage Guide

## Overview
The Fire Fighting Mission game now uses a comprehensive TileSet system with organized collision layers and tile categories. This system provides:
- 5 distinct tile layers with proper collision handling
- Damage zones for fire/smoke effects
- Interactive objects and trigger areas
- Seamless integration with player movement

## TileSet Structure

### Collision Layers
- **Layer 0 (Floor)**: Walkable surfaces with no collision
- **Layer 1 (Wall)**: Collision surfaces that block movement
- **Layer 2 (Interactive)**: Objects that can be interacted with
- **Layer 3 (Damage)**: Areas that deal damage to the player
- **Layer 4 (Trigger)**: Areas that trigger events/transitions

### Tile Categories

#### Floor Tiles (Walkable)
- `CONCRETE_FLOOR`: Fire-resistant concrete flooring
- `WOOD_FLOOR`: Flammable wooden floors
- `CARPET`: Highly flammable carpet
- `GRASS`: Outdoor grass surface

#### Wall Tiles (Collision)
- `CONCRETE_WALL`: High fire resistance
- `BRICK_WALL`: Moderate fire resistance
- `WOOD_WALL`: Low fire resistance, flammable

#### Interactive Tiles
- `DOOR`: Can be opened/closed
- `FURNITURE`: Can be moved or destroyed
- `WINDOW`: Can be broken for escape

#### Damage Tiles
- `FIRE_DAMAGE`: Deals fire damage over time
- `SMOKE_DAMAGE`: Deals suffocation damage
- `DEBRIS`: Blocks movement and causes damage

#### Trigger Tiles
- `SCENE_TRANSITION`: Triggers scene changes
- `MISSION_TRIGGER`: Starts mission events
- `STORY_TRIGGER`: Triggers story events

## Usage Instructions

### Setting Up a New Scene

1. **Use the Template**: Start with `fire_mission_scene_template.tscn`
2. **Add TileMapManager**: The template includes a pre-configured TileMapManager
3. **Configure Layers**: Each layer is already set up with proper collision masks

### Placing Tiles

Use the TileMapManager functions to place tiles:

```gdscript
# Place a concrete floor tile
tilemap_manager.place_floor_tile(Vector2i(10, 10), TileMapManager.TileTypes.CONCRETE_FLOOR)

# Place a wall tile
tilemap_manager.place_wall_tile(Vector2i(10, 9), TileMapManager.TileTypes.CONCRETE_WALL)

# Place damage tiles for fire areas
tilemap_manager.place_damage_tile(Vector2i(12, 10), TileMapManager.TileTypes.FIRE_DAMAGE)
```

### Player Integration

The player automatically:
- Detects tile-based damage and takes damage over time
- Checks tile walkability for movement
- Integrates with all collision layers

### Getting Tile Information

```gdscript
# Get current tile info where player is standing
var tile_info = player.get_current_tile_info()
print("Player is on: ", tile_info)

# Check if a position is walkable
var is_walkable = tilemap_manager.is_tile_walkable(wall_layer, tile_position)
```

## Scene Examples

### Fire Station Scene
- Uses concrete floors for main areas
- Walls define the station layout
- Interactive objects for equipment
- No damage or trigger tiles needed

### Mission Scenes
- Mixed floor types (concrete, wood, carpet)
- Damage tiles for fire and smoke areas
- Trigger tiles for objectives
- Interactive objects for mission elements

## Best Practices

1. **Layer Organization**: Always place tiles on the correct layer
2. **Collision Setup**: Ensure collision layers match tile purposes
3. **Performance**: Use simple geometric shapes for collision
4. **Consistency**: Follow the established tile categories
5. **Testing**: Test player movement and damage detection

## Troubleshooting

### Common Issues
- **Player not taking damage**: Check if damage tiles are on the DamageLayer
- **Movement blocked**: Verify wall tiles are on WallLayer with proper collision
- **Tiles not appearing**: Ensure TileSet resource is assigned to all layers

### Debug Functions
```gdscript
# Check tile at position
var tile_data = tilemap_manager.get_tile_data(layer, position)

# Convert between world and tile coordinates
var tile_pos = tilemap_manager.world_to_tile(world_position)
var world_pos = tilemap_manager.tile_to_world(tile_position)
```

This system provides a solid foundation for creating structured, collision-aware levels for the Fire Fighting Mission game.