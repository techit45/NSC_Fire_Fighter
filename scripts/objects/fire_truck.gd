extends Area2D
class_name FireTruck

var player_stats_ui = null

func _ready():
	add_to_group("Interactables")
	print("Fire Truck initialized")

func start_interaction():
	if GameManager.current_mission:
		perform_equipment_check()
	else:
		print("No mission selected! Go to the map board first.")

func perform_equipment_check():
	var equipped_tools = GameManager.get_equipped_tools()
	var current_mission = GameManager.current_mission
	
	print("=== EQUIPMENT CHECK ===")
	print("Mission: ", current_mission.location)
	print("Required fire types: ", current_mission.fire_types)
	print("Equipped tools: ", equipped_tools)
	
	# Check if player has appropriate tools for the mission
	var has_required_tools = false
	for fire_type in current_mission.fire_types:
		match fire_type:
			"CLASS_A":
				if "WATER" in equipped_tools or "WATER_UPGRADED" in equipped_tools or "FOAM" in equipped_tools:
					has_required_tools = true
			"CLASS_B":
				if "POWDER" in equipped_tools or "FOAM" in equipped_tools:
					has_required_tools = true
			"CLASS_C":
				if "CO2" in equipped_tools or "HALON" in equipped_tools:
					has_required_tools = true
	
	if has_required_tools:
		confirm_mission_readiness()
	else:
		print("WARNING: You may not have the right equipment for this mission!")
		print("Continue anyway? Go to Equipment Table to change loadout.")
		# For now, still allow mission to continue
		confirm_mission_readiness()

func confirm_mission_readiness():
	print("=== MISSION BRIEFING ===")
	var mission = GameManager.current_mission
	print("Location: ", mission.location)
	print("Description: ", mission.description)
	print("Difficulty: ★", "★".repeat(mission.difficulty))
	print("Reward: ", mission.reward_money, " บาท, ", mission.reward_exp, " EXP")
	print("Starting mission in 3 seconds...")
	
	# Delay then start mission
	await get_tree().create_timer(1.0).timeout
	begin_mission_journey()

func begin_mission_journey():
	print("🚒 Departing to ", GameManager.current_mission.location, "!")
	
	# Load appropriate mission scene based on mission ID
	var mission_scene_path = get_mission_scene_path(GameManager.current_mission.id)
	if mission_scene_path:
		GameManager.change_scene(mission_scene_path)
	else:
		print("Mission scene not found! Using default mission.")
		GameManager.change_scene(GameManager.MISSION_SCENE)

func get_mission_scene_path(mission_id: String) -> String:
	match mission_id:
		"bangkok_01":
			return "res://scenes/levels/mission_bangkok.tscn"
		"chiang_mai_01":
			return "res://scenes/levels/mission_chiang_mai.tscn"
		"phuket_01":
			return "res://scenes/levels/mission_phuket.tscn"
		"khon_kaen_01":
			return "res://scenes/levels/mission_khon_kaen.tscn"
		_:
			return "res://scenes/levels/level_01.tscn"  # Default fallback

func end_interaction():
	print("Left fire truck area")