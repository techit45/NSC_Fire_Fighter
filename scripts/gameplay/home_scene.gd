extends Node2D

@onready var player = $Player
@onready var scene_transition = $SceneTransition

func _ready():
	print("Home scene initialized")
	
	# Connect scene transition
	scene_transition.area_entered.connect(_on_scene_transition_entered)
	
	# Debug: Check scene structure
	print("=== HOME SCENE DEBUG ===")
	print("Player: ", player != null)
	print("SceneTransition: ", scene_transition != null)
	
	# Check UILayer and DialogueManager
	if has_node("UILayer"):
		print("UILayer found!")
		var ui_layer = get_node("UILayer")
		if ui_layer.has_node("DialogueManager"):
			print("DialogueManager found!")
		else:
			print("DialogueManager NOT found in UILayer")
	else:
		print("UILayer NOT found!")
	
	# Check NPCs
	var npcs = get_tree().get_nodes_in_group("NPCs")
	print("NPCs in scene: ", npcs.size())
	for npc in npcs:
		print("  - ", npc.name, " at position: ", npc.position)

func _on_scene_transition_entered(area):
	if area == player.interaction_area:
		# Check if talked to mother before leaving
		if GameManager.get_story_stage() >= GameManager.StoryProgress.TALKED_TO_MOTHER:
			print("Transitioning to Fire Station")
			GameManager.advance_story_progress()
			GameManager.change_scene(GameManager.FIRE_STATION_SCENE)
		else:
			print("Talk to Mother first before leaving!")