extends Area2D
class_name MapBoard

@export var thailand_missions: Array = []
var map_ui = null

func _ready():
	add_to_group("Interactables")
	# Get missions from GameManager
	thailand_missions = GameManager.get_available_missions()
	print("Map Board initialized with ", thailand_missions.size(), " available missions")

func start_interaction():
	if not map_ui:
		find_map_ui()
	
	if map_ui:
		# Update available missions before opening
		thailand_missions = GameManager.get_available_missions()
		map_ui.open_map(thailand_missions)
		print("Opened Thailand map")
	else:
		print("Map UI not found!")

func find_map_ui():
	# Try to find map UI in the scene
	var scene_root = get_tree().current_scene
	if scene_root.has_node("UILayer/MapUI"):
		map_ui = scene_root.get_node("UILayer/MapUI")
	elif scene_root.has_node("CanvasLayer/MapUI"):
		map_ui = scene_root.get_node("CanvasLayer/MapUI")

func select_mission_location(mission_id: String) -> bool:
	return GameManager.select_mission(mission_id)

func get_player_level() -> int:
	return GameManager.player_level

func end_interaction():
	if map_ui:
		map_ui.close_map()
	print("Closed Thailand map")