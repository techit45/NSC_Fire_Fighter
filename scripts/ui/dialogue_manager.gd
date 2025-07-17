extends Control

# UI elements
@onready var dialogue_box = $DialogueBox
@onready var character_name = $DialogueBox/CharacterName
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var continue_prompt = $DialogueBox/ContinuePrompt

# Dialogue state
var current_dialogue = []
var dialogue_index = 0
var is_dialogue_active = false
var dialogue_finished_callback = null

# Signals
signal dialogue_finished

func _ready():
	visible = false
	# Set process mode to always so it works when game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("Dialogue Manager initialized")

func _input(event):
	if is_dialogue_active and event.is_action_pressed("ui_accept"):
		advance_dialogue()

func start_dialogue(dialogue_data: Array, callback = null):
	if dialogue_data.is_empty():
		print("Warning: Empty dialogue data")
		return
		
	current_dialogue = dialogue_data
	dialogue_index = 0
	is_dialogue_active = true
	dialogue_finished_callback = callback
	
	visible = true
	get_tree().paused = true
	
	display_current_dialogue()
	print("Started dialogue with ", dialogue_data.size(), " lines")

func advance_dialogue():
	dialogue_index += 1
	
	if dialogue_index >= current_dialogue.size():
		end_dialogue()
	else:
		display_current_dialogue()

func display_current_dialogue():
	if dialogue_index < current_dialogue.size():
		var dialogue_line = current_dialogue[dialogue_index]
		character_name.text = dialogue_line.get("speaker", "Unknown")
		dialogue_text.text = dialogue_line.get("text", "...")
		
		# Show continue prompt
		if dialogue_index < current_dialogue.size() - 1:
			continue_prompt.text = "Press SPACE to continue..."
		else:
			continue_prompt.text = "Press SPACE to finish..."

func end_dialogue():
	is_dialogue_active = false
	visible = false
	get_tree().paused = false
	
	dialogue_finished.emit()
	
	if dialogue_finished_callback:
		dialogue_finished_callback.call()
	
	print("Dialogue ended")