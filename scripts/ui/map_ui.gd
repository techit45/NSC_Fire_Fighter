extends Control
class_name MapUI

# UI elements
@onready var map_panel = $MapPanel
@onready var mission_list = $MapPanel/VBoxContainer/ScrollContainer/MissionList
@onready var player_level_label = $MapPanel/VBoxContainer/PlayerLevelLabel
@onready var close_button = $MapPanel/VBoxContainer/CloseButton
@onready var select_button = $MapPanel/VBoxContainer/SelectButton
@onready var mission_description = $MapPanel/VBoxContainer/DescriptionLabel

# Mission data
var current_missions: Array = []
var selected_mission_index: int = -1

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Connect signals
	if close_button:
		close_button.pressed.connect(close_map)
	if select_button:
		select_button.pressed.connect(select_mission)
	if mission_list:
		mission_list.item_selected.connect(_on_mission_selected)
	
	print("Map UI initialized")

func open_map(missions: Array):
	current_missions = missions
	
	# Clear and populate mission list
	if mission_list:
		mission_list.clear()
		for mission in current_missions:
			var difficulty_stars = "★".repeat(mission.difficulty)
			var display_text = "%s (%s) - %d บาท" % [mission.location, difficulty_stars, mission.reward_money]
			mission_list.add_item(display_text)
			
			# Color code based on difficulty and player level
			var item_index = mission_list.get_item_count() - 1
			if mission.difficulty > GameManager.player_level:
				mission_list.set_item_custom_bg_color(item_index, Color.RED * 0.3)
			elif mission.difficulty == GameManager.player_level:
				mission_list.set_item_custom_bg_color(item_index, Color.YELLOW * 0.3)
			else:
				mission_list.set_item_custom_bg_color(item_index, Color.GREEN * 0.3)
	
	# Update player level display
	if player_level_label:
		player_level_label.text = "ระดับผู้เล่น: %d" % GameManager.player_level
	
	# Show map
	visible = true
	get_tree().paused = true
	print("Map opened with ", missions.size(), " missions")

func close_map():
	visible = false
	get_tree().paused = false
	selected_mission_index = -1
	print("Map closed")

func _on_mission_selected(index: int):
	selected_mission_index = index
	if index >= 0 and index < current_missions.size():
		var mission = current_missions[index]
		if mission_description:
			var fire_types_text = ", ".join(mission.fire_types)
			var description_text = "%s\nประเภทไฟ: %s\nรางวัล: %d บาท, %d EXP\nความยาก: ★%s" % [
				mission.description,
				fire_types_text,
				mission.reward_money,
				mission.reward_exp,
				"★".repeat(mission.difficulty)
			]
			mission_description.text = description_text
		
		# Enable/disable select button based on player level
		if select_button:
			select_button.disabled = mission.difficulty > GameManager.player_level

func select_mission():
	if selected_mission_index >= 0 and selected_mission_index < current_missions.size():
		var mission = current_missions[selected_mission_index]
		
		if GameManager.select_mission(mission.id):
			print("Selected mission: ", mission.location)
			close_map()
		else:
			print("Failed to select mission: ", mission.location)

func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):
		close_map()