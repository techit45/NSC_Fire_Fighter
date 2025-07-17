extends CharacterBody2D

# Core player variables
@export var speed = 300.0
var health = 100
var current_tool = "WATER"
var available_tools = ["WATER", "POWDER", "CO2"]
var current_tool_index = 0

# Interaction system variables
var can_interact = false
var current_interactable = null

# TileMap integration variables
var tilemap_manager: TileMapManager
var current_damage_tiles = []
var damage_timer = 0.0

# Node references
@onready var interaction_area = $InteractionArea
@onready var interaction_prompt = $InteractionPrompt
@onready var player_sprite = $PlayerSprite
var tool_label = null

func _ready():
	# Get tool label reference when available
	call_deferred("get_tool_label")
	
	# Initialize current tool from GameManager
	var equipped_tools = GameManager.get_equipped_tools()
	if equipped_tools.size() > 0:
		current_tool = equipped_tools[0]
		current_tool_index = 0
	
	update_tool_label()
	
	# Setup interaction area signals
	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)
	
	# Hide interaction prompt initially
	if interaction_prompt:
		interaction_prompt.visible = false
	
	# Initialize player sprite animation
	if player_sprite:
		player_sprite.play("idle")
		player_sprite.flip_h = false  # Reset flip state
	
	# Find TileMapManager in the scene
	call_deferred("find_tilemap_manager")
	
	print("Player initialized with health: ", health)
	print("Player initialized with tool: ", current_tool)

func find_tilemap_manager():
	# Find TileMapManager in the current scene
	var scene_root = get_tree().current_scene
	if scene_root:
		var tilemap_nodes = scene_root.find_children("*", "TileMapManager", true, false)
		if tilemap_nodes.size() > 0:
			tilemap_manager = tilemap_nodes[0]
			print("TileMapManager found: ", tilemap_manager.name)
		else:
			print("TileMapManager not found in scene")

func get_tool_label():
	# Try to get the tool label from the current scene
	var scene_root = get_tree().current_scene
	if scene_root:
		# Try mission scene path first
		if scene_root.has_node("CanvasLayer/ToolLabel"):
			tool_label = scene_root.get_node("CanvasLayer/ToolLabel")
			update_tool_label()
		# Try UILayer path (for story scenes)
		elif scene_root.has_node("UILayer/ToolLabel"):
			tool_label = scene_root.get_node("UILayer/ToolLabel")
			update_tool_label()

func _physics_process(delta):
	handle_movement()
	
	# Use Godot's built-in collision detection with TileMap
	move_and_slide()
	
	# Check for tile-based damage
	if tilemap_manager:
		check_tile_damage(delta)

func _input(event):
	if event.is_action_pressed("ui_select"):
		# Only allow tool switching in mission scenes or after learning equipment
		if GameManager.get_story_stage() >= GameManager.StoryProgress.LEARNED_EQUIPMENT:
			switch_tool()
	elif event.is_action_pressed("ui_accept"):
		if can_interact and current_interactable:
			interact_with_object()
		else:
			# Always allow tool use in mission scenes
			print("SPACE pressed - attempting to use tool")
			use_tool()

func handle_movement():
	# Get input direction vector
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Apply movement and directional animation
	if input_dir != Vector2.ZERO:
		# Set velocity for move_and_slide() to handle collision
		velocity = input_dir * speed
		
		# Determine animation based on direction
		var animation_name = get_directional_animation(input_dir)
		
		# Play appropriate directional animation
		if player_sprite.animation != animation_name:
			player_sprite.play(animation_name)
			
	else:
		velocity = Vector2.ZERO
		
		# Play idle animation
		if player_sprite.animation != "idle":
			player_sprite.play("idle")

func get_directional_animation(direction: Vector2) -> String:
	# Determine primary direction based on input
	# Available animations: idle, walk_front, walk_back, walk_left, walk_right
	# Use absolute values to find strongest direction
	var abs_x = abs(direction.x)
	var abs_y = abs(direction.y)
	
	# If horizontal movement is stronger or equal
	if abs_x >= abs_y:
		if direction.x > 0:
			return "walk_right"  # Moving right
		else:
			return "walk_left"   # Moving left
	# If vertical movement is stronger
	else:
		if direction.y > 0:
			return "walk_front"  # Moving down (towards screen/front)
		else:
			return "walk_back"   # Moving up (away from screen/back)

func switch_tool():
	# Get equipped tools from GameManager
	var equipped_tools = GameManager.get_equipped_tools()
	print("Available equipped tools: ", equipped_tools)
	if equipped_tools.size() > 0:
		current_tool_index = (current_tool_index + 1) % equipped_tools.size()
		current_tool = equipped_tools[current_tool_index]
		update_tool_label()
		print("Switched to tool: ", current_tool)
	else:
		print("No tools equipped! Go to Equipment Table.")

func update_tool_label():
	if tool_label:
		tool_label.text = "Current Tool: " + current_tool

func use_tool():
	print("=== USE TOOL DEBUG ===")
	print("Current tool: ", current_tool)
	print("Interaction area: ", interaction_area)
	
	# Check for overlapping fires in interaction area
	var overlapping_areas = interaction_area.get_overlapping_areas()
	print("Overlapping areas: ", overlapping_areas.size())
	
	var fires_hit = 0
	
	for area in overlapping_areas:
		print("Area found: ", area.name, " - Groups: ", area.get_groups())
		if area.is_in_group("Fires"):
			print("Fire detected! Calling take_damage with: ", current_tool)
			area.take_damage(current_tool)
			fires_hit += 1
	
	if fires_hit > 0:
		print("Used ", current_tool, " on ", fires_hit, " fire(s)")
	else:
		print("Used ", current_tool, " but no fires in range")
	print("=== END DEBUG ===")

func take_damage(amount):
	health -= amount
	GameManager.player_health = health
	print("Player took ", amount, " damage. Health: ", health)
	
	if health <= 0:
		print("Player defeated!")
		# Game over logic will be handled by level manager

# Interaction system functions
func _on_interaction_area_entered(area):
	if area.is_in_group("NPCs") or area.is_in_group("Interactables"):
		can_interact = true
		current_interactable = area
		show_interact_prompt(true)
		print("Can interact with: ", area.name)

func _on_interaction_area_exited(area):
	if area == current_interactable:
		can_interact = false
		current_interactable = null
		show_interact_prompt(false)
		print("Left interaction range of: ", area.name)

func show_interact_prompt(should_show: bool):
	if interaction_prompt:
		interaction_prompt.visible = should_show

func interact_with_object():
	if current_interactable and current_interactable.has_method("start_interaction"):
		current_interactable.start_interaction()
		print("Interacting with: ", current_interactable.name)

# TileMap integration functions
func check_tile_damage(delta):
	if not tilemap_manager:
		return
	
	var player_tile_pos = tilemap_manager.world_to_tile(global_position)
	var damage_tile_data = tilemap_manager.get_tile_data(tilemap_manager.damage_layer, player_tile_pos)
	
	if damage_tile_data:
		var tile_type = damage_tile_data.get_custom_data("tile_type")
		var damage_amount = TileCategories.get_tile_damage(tile_type)
		
		if damage_amount > 0:
			damage_timer += delta
			if damage_timer >= 1.0:  # Apply damage every second
				take_damage(damage_amount)
				damage_timer = 0.0
				print("Taking tile damage: ", damage_amount, " from ", tile_type)
	else:
		damage_timer = 0.0

func check_tile_walkability(target_position: Vector2) -> bool:
	if not tilemap_manager:
		return true
	
	var tile_pos = tilemap_manager.world_to_tile(target_position)
	
	# Check wall layer for collision
	var wall_walkable = tilemap_manager.is_tile_walkable(tilemap_manager.wall_layer, tile_pos)
	
	# Check interactive layer for collision
	var interactive_walkable = tilemap_manager.is_tile_walkable(tilemap_manager.interactive_layer, tile_pos)
	
	return wall_walkable and interactive_walkable

func get_current_tile_info() -> Dictionary:
	if not tilemap_manager:
		return {}
	
	var tile_pos = tilemap_manager.world_to_tile(global_position)
	var info = {}
	
	# Get floor tile info
	var floor_type = tilemap_manager.get_tile_type(tilemap_manager.floor_layer, tile_pos)
	if floor_type != "":
		info["floor"] = floor_type
	
	# Get wall tile info
	var wall_type = tilemap_manager.get_tile_type(tilemap_manager.wall_layer, tile_pos)
	if wall_type != "":
		info["wall"] = wall_type
	
	# Get interactive tile info
	var interactive_type = tilemap_manager.get_tile_type(tilemap_manager.interactive_layer, tile_pos)
	if interactive_type != "":
		info["interactive"] = interactive_type
	
	# Get damage tile info
	var damage_type = tilemap_manager.get_tile_type(tilemap_manager.damage_layer, tile_pos)
	if damage_type != "":
		info["damage"] = damage_type
	
	# Get trigger tile info
	var trigger_type = tilemap_manager.get_tile_type(tilemap_manager.trigger_layer, tile_pos)
	if trigger_type != "":
		info["trigger"] = trigger_type
	
	return info
