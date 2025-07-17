extends Area2D
class_name EquipmentTable

@export var available_slots: int = 3
var equipped_tools: Array = []
var inventory_ui = null

func _ready():
	add_to_group("Interactables")
	print("Equipment Table initialized")

func start_interaction():
	if not inventory_ui:
		find_inventory_ui()
	
	if inventory_ui:
		inventory_ui.open_inventory()
		print("Opened equipment selection")
	else:
		print("Inventory UI not found!")

func find_inventory_ui():
	# Try to find inventory UI in the scene
	var scene_root = get_tree().current_scene
	if scene_root.has_node("UILayer/InventoryUI"):
		inventory_ui = scene_root.get_node("UILayer/InventoryUI")
	elif scene_root.has_node("CanvasLayer/InventoryUI"):
		inventory_ui = scene_root.get_node("CanvasLayer/InventoryUI")

func equip_tool(tool_name: String) -> bool:
	return GameManager.equip_tool(tool_name)

func unequip_tool(tool_name: String):
	GameManager.unequip_tool(tool_name)

func get_equipped_tools() -> Array:
	return GameManager.get_equipped_tools()

func get_owned_equipment() -> Array:
	return GameManager.get_owned_equipment()

func end_interaction():
	if inventory_ui:
		inventory_ui.close_inventory()
	print("Closed equipment selection")