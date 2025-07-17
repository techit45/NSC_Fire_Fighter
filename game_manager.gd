extends Node

# Game state tracking
var current_scene_name = ""
var story_progress = 0
var completed_tutorials = []
var player_health = 100

# Player progression system
var player_level = 1
var player_experience = 0
var player_money = 1000  # Starting money
var experience_to_next_level = 100

# Equipment and inventory system
var owned_equipment = ["WATER"]  # Starting equipment
var equipped_tools = ["WATER"]  # Currently equipped
var max_equipment_slots = 3

# Mission system
var available_missions = []
var completed_missions = []
var current_mission = null

# Story progress constants
enum StoryProgress {
	START_HOME = 0,
	TALKED_TO_MOTHER = 1,
	AT_FIRE_STATION = 2,
	LEARNED_EQUIPMENT = 3,
	FIRST_MISSION = 4,
	MISSION_COMPLETE = 5
}

# Scene paths
const HOME_SCENE = "res://scenes/home_scene.tscn"
const FIRE_STATION_SCENE = "res://scenes/fire_station_scene.tscn"
const MISSION_SCENE = "res://scenes/levels/level_01.tscn"

func _ready():
	print("Game Manager initialized")
	current_scene_name = "home_scene"
	initialize_missions()

func change_scene(scene_path: String):
	print("Changing scene to: ", scene_path)
	get_tree().call_deferred("change_scene_to_file", scene_path)
	
	# Update current scene name
	if scene_path.contains("home_scene"):
		current_scene_name = "home_scene"
	elif scene_path.contains("fire_station_scene"):
		current_scene_name = "fire_station_scene"
	elif scene_path.contains("mission_level"):
		current_scene_name = "mission_scene"

func advance_story_progress():
	story_progress += 1
	print("Story progress advanced to: ", story_progress)
	save_progress()

func mark_tutorial_complete(tutorial_name: String):
	if tutorial_name not in completed_tutorials:
		completed_tutorials.append(tutorial_name)
		print("Tutorial completed: ", tutorial_name)
		save_progress()

func is_tutorial_completed(tutorial_name: String) -> bool:
	return tutorial_name in completed_tutorials

func save_progress():
	# In a full game, this would save to file
	# For now, just print the current state
	print("Progress saved - Story: ", story_progress, ", Tutorials: ", completed_tutorials)

func load_progress():
	# In a full game, this would load from file
	print("Progress loaded")

func get_story_stage() -> StoryProgress:
	return story_progress as StoryProgress

# Player progression functions
func add_experience(amount: int):
	player_experience += amount
	print("Gained ", amount, " experience. Total: ", player_experience)
	
	# Check for level up
	while player_experience >= experience_to_next_level:
		level_up()

func add_money(amount: int):
	player_money += amount
	print("Gained ", amount, " money. Total: ", player_money)

func spend_money(amount: int) -> bool:
	if player_money >= amount:
		player_money -= amount
		print("Spent ", amount, " money. Remaining: ", player_money)
		return true
	else:
		print("Not enough money! Need ", amount, ", have ", player_money)
		return false

func level_up():
	player_experience -= experience_to_next_level
	player_level += 1
	experience_to_next_level = player_level * 100  # Increasing requirement
	print("LEVEL UP! Now level ", player_level)

func get_player_stats() -> Dictionary:
	return {
		"level": player_level,
		"experience": player_experience,
		"money": player_money,
		"health": player_health,
		"exp_to_next": experience_to_next_level
	}

# Equipment management functions
func purchase_equipment(item_name: String, price: int) -> bool:
	if spend_money(price):
		if item_name not in owned_equipment:
			owned_equipment.append(item_name)
			print("Purchased equipment: ", item_name)
			return true
		else:
			print("Already own ", item_name)
			add_money(price)  # Refund
			return false
	return false

func equip_tool(tool_name: String) -> bool:
	if tool_name in owned_equipment:
		if tool_name not in equipped_tools:
			if equipped_tools.size() < max_equipment_slots:
				equipped_tools.append(tool_name)
				print("Equipped: ", tool_name)
				return true
			else:
				print("Equipment slots full!")
				return false
		else:
			print("Already equipped: ", tool_name)
			return false
	else:
		print("Don't own equipment: ", tool_name)
		return false

func unequip_tool(tool_name: String):
	if tool_name in equipped_tools:
		equipped_tools.erase(tool_name)
		print("Unequipped: ", tool_name)

func get_owned_equipment() -> Array:
	return owned_equipment.duplicate()

func get_equipped_tools() -> Array:
	return equipped_tools.duplicate()

# Mission management functions
func initialize_missions():
	available_missions = [
		{
			"id": "bangkok_01",
			"location": "กรุงเทพฯ", 
			"difficulty": 1, 
			"reward_money": 500,
			"reward_exp": 50,
			"fire_types": ["CLASS_A"],
			"description": "ไฟไหม้ในตลาดเก่า",
			"unlocked": true
		},
		{
			"id": "chiang_mai_01",
			"location": "เชียงใหม่", 
			"difficulty": 2, 
			"reward_money": 750,
			"reward_exp": 75,
			"fire_types": ["CLASS_A", "CLASS_B"],
			"description": "ไฟไหม้โรงงานไม้",
			"unlocked": false
		},
		{
			"id": "phuket_01",
			"location": "ภูเก็ต", 
			"difficulty": 3, 
			"reward_money": 1000,
			"reward_exp": 100,
			"fire_types": ["CLASS_B", "CLASS_C"],
			"description": "ไฟไหม้โรงแรม",
			"unlocked": false
		},
		{
			"id": "khon_kaen_01",
			"location": "ขอนแก่น", 
			"difficulty": 2, 
			"reward_money": 800,
			"reward_exp": 80,
			"fire_types": ["CLASS_A", "CLASS_C"],
			"description": "ไฟไหม้โรงพยาบาล",
			"unlocked": false
		}
	]

func select_mission(mission_id: String):
	for mission in available_missions:
		if mission.id == mission_id and mission.unlocked:
			current_mission = mission
			print("Selected mission: ", mission.location)
			return true
	return false

func complete_mission(success: bool):
	if current_mission and success:
		add_money(current_mission.reward_money)
		add_experience(current_mission.reward_exp)
		
		# Add to completed missions
		if current_mission.id not in completed_missions:
			completed_missions.append(current_mission.id)
		
		# Unlock new missions
		unlock_new_locations()
		
		print("Mission completed: ", current_mission.location)
		current_mission = null

func get_available_missions() -> Array:
	return available_missions.filter(func(mission): return mission.unlocked)

func unlock_new_locations():
	# Unlock missions based on level
	for mission in available_missions:
		if mission.difficulty <= player_level and not mission.unlocked:
			mission.unlocked = true
			print("Unlocked new location: ", mission.location)