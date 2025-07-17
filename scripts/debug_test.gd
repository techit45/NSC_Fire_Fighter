extends Node

# Simple debug script to test dialogue system

func _ready():
	print("=== DEBUG TEST STARTED ===")
	
	# Test 1: Check if GameManager is accessible
	print("GameManager exists: ", GameManager != null)
	if GameManager:
		print("Current story stage: ", GameManager.get_story_stage())
	
	# Test 2: Find current scene structure
	var scene_root = get_tree().current_scene
	print("Current scene: ", scene_root.name)
	
	# Test 3: Check for UILayer
	if scene_root.has_node("UILayer"):
		print("UILayer found!")
		var ui_layer = scene_root.get_node("UILayer")
		if ui_layer.has_node("DialogueManager"):
			print("DialogueManager found in UILayer!")
		else:
			print("DialogueManager NOT found in UILayer")
	else:
		print("UILayer NOT found")
	
	# Test 4: Check for NPCs
	var npcs = get_tree().get_nodes_in_group("NPCs")
	print("NPCs found: ", npcs.size())
	for npc in npcs:
		print("  - ", npc.name)
	
	print("=== DEBUG TEST COMPLETED ===")