extends Area2D
class_name NPCBase

@export var npc_name: String = "NPC"
@export var dialogue_data: Array = []
@export var can_repeat_dialogue: bool = true

# Node references
var dialogue_manager = null
var has_talked = false

func _ready():
	# Add to NPCs group
	add_to_group("NPCs")
	print("NPC initialized: ", npc_name)

func start_interaction():
	# Find dialogue manager in the scene
	find_dialogue_manager()
	
	if dialogue_manager and not dialogue_data.is_empty():
		# Check if this is first time talking or can repeat
		if not has_talked or can_repeat_dialogue:
			dialogue_manager.start_dialogue(dialogue_data, func(): on_dialogue_finished())
			print("Started dialogue with: ", npc_name)
		else:
			print(npc_name, " has nothing new to say")
	else:
		print("No dialogue manager or dialogue data for: ", npc_name)

func find_dialogue_manager():
	# Try to find dialogue manager in the scene
	var scene_root = get_tree().current_scene
	if scene_root:
		# Try UILayer first (story scenes)
		if scene_root.has_node("UILayer"):
			var ui_layer = scene_root.get_node("UILayer")
			if ui_layer.has_node("DialogueManager"):
				dialogue_manager = ui_layer.get_node("DialogueManager")
				print("Found DialogueManager in UILayer")
				return
		
		# Try CanvasLayer (mission scenes)
		if scene_root.has_node("CanvasLayer"):
			var canvas_layer = scene_root.get_node("CanvasLayer")
			if canvas_layer.has_node("DialogueManager"):
				dialogue_manager = canvas_layer.get_node("DialogueManager")
				print("Found DialogueManager in CanvasLayer")
				return
		
		print("Warning: DialogueManager not found in scene: ", scene_root.name)

func on_dialogue_finished():
	has_talked = true
	# Override in derived classes for specific behavior
	print("Dialogue finished with: ", npc_name)

func end_interaction():
	# Called when player moves away
	print("Ended interaction with: ", npc_name)