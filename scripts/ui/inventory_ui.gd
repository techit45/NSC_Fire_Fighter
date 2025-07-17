extends Control
class_name InventoryUI

# UI elements
@onready var inventory_panel = $InventoryPanel
@onready var owned_list = $InventoryPanel/HBoxContainer/LeftPanel/VBoxContainer/OwnedList
@onready var equipped_list = $InventoryPanel/HBoxContainer/RightPanel/VBoxContainer/EquippedList
@onready var equip_button = $InventoryPanel/HBoxContainer/LeftPanel/VBoxContainer/EquipButton
@onready var unequip_button = $InventoryPanel/HBoxContainer/RightPanel/VBoxContainer/UnequipButton
@onready var close_button = $InventoryPanel/CloseButton

# Selection tracking
var selected_owned_index: int = -1
var selected_equipped_index: int = -1

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Connect signals
	if close_button:
		close_button.pressed.connect(close_inventory)
	if equip_button:
		equip_button.pressed.connect(equip_selected_item)
	if unequip_button:
		unequip_button.pressed.connect(unequip_selected_item)
	if owned_list:
		owned_list.item_selected.connect(_on_owned_item_selected)
	if equipped_list:
		equipped_list.item_selected.connect(_on_equipped_item_selected)
	
	print("Inventory UI initialized")

func open_inventory():
	update_inventory_display()
	visible = true
	get_tree().paused = true
	print("Inventory opened")

func close_inventory():
	visible = false
	get_tree().paused = false
	print("Inventory closed")

func update_inventory_display():
	# Clear lists
	if owned_list:
		owned_list.clear()
	if equipped_list:
		equipped_list.clear()
	
	# Populate owned equipment
	var owned = GameManager.get_owned_equipment()
	var equipped = GameManager.get_equipped_tools()
	
	if owned_list:
		for item in owned:
			owned_list.add_item(get_equipment_display_name(item))
	
	# Populate equipped equipment
	if equipped_list:
		for item in equipped:
			equipped_list.add_item(get_equipment_display_name(item))
		
		# Add empty slots
		for i in range(equipped.size(), GameManager.max_equipment_slots):
			equipped_list.add_item("(ช่องว่าง)")
	
	# Update button states
	update_button_states()

func get_equipment_display_name(item_name: String) -> String:
	match item_name:
		"WATER":
			return "ถังน้ำ"
		"POWDER":
			return "ถังผงเคมี"
		"CO2":
			return "ถัง CO2"
		"FOAM":
			return "ถังโฟม"
		"HALON":
			return "ถังเฮลอน"
		"WATER_UPGRADED":
			return "ถังน้ำแรงดันสูง"
		_:
			return item_name

func _on_owned_item_selected(index: int):
	selected_owned_index = index
	selected_equipped_index = -1
	if equipped_list:
		equipped_list.deselect_all()
	update_button_states()

func _on_equipped_item_selected(index: int):
	selected_equipped_index = index
	selected_owned_index = -1
	if owned_list:
		owned_list.deselect_all()
	update_button_states()

func update_button_states():
	if equip_button:
		equip_button.disabled = selected_owned_index == -1 or GameManager.get_equipped_tools().size() >= GameManager.max_equipment_slots
	
	if unequip_button:
		var equipped = GameManager.get_equipped_tools()
		unequip_button.disabled = selected_equipped_index == -1 or selected_equipped_index >= equipped.size()

func equip_selected_item():
	if selected_owned_index >= 0:
		var owned = GameManager.get_owned_equipment()
		if selected_owned_index < owned.size():
			var item_name = owned[selected_owned_index]
			if GameManager.equip_tool(item_name):
				update_inventory_display()

func unequip_selected_item():
	if selected_equipped_index >= 0:
		var equipped = GameManager.get_equipped_tools()
		if selected_equipped_index < equipped.size():
			var item_name = equipped[selected_equipped_index]
			GameManager.unequip_tool(item_name)
			update_inventory_display()

func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):
		close_inventory()