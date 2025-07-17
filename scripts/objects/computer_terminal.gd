extends Area2D
class_name ComputerTerminal

@export var shop_items: Array = [
	{"name": "POWDER", "price": 1000, "description": "ถังผงเคมีแห้ง - สำหรับไฟน้ำมัน"},
	{"name": "CO2", "price": 1500, "description": "ถังคาร์บอนไดออกไซด์ - สำหรับไฟไฟฟ้า"},
	{"name": "FOAM", "price": 2000, "description": "ถังโฟม - สำหรับไฟน้ำมันขนาดใหญ่"},
	{"name": "HALON", "price": 3000, "description": "ถังเฮลอน - สำหรับไฟพิเศษ"},
	{"name": "WATER_UPGRADED", "price": 800, "description": "ถังน้ำแรงดันสูง - อัปเกรดจากน้ำธรรมดา"}
]

# Node references
var shop_ui = null
var player = null
var has_talked = false

func _ready():
	add_to_group("Interactables")
	print("Computer Terminal initialized with ", shop_items.size(), " items")

func start_interaction():
	if not shop_ui:
		find_shop_ui()
	
	if shop_ui:
		shop_ui.open_shop(shop_items)
		print("Opened shop interface")
	else:
		print("Shop UI not found!")

func find_shop_ui():
	# Try to find shop UI in the scene
	var scene_root = get_tree().current_scene
	if scene_root.has_node("UILayer/ShopUI"):
		shop_ui = scene_root.get_node("UILayer/ShopUI")
	elif scene_root.has_node("CanvasLayer/ShopUI"):
		shop_ui = scene_root.get_node("CanvasLayer/ShopUI")

func purchase_equipment(item_name: String, price: int) -> bool:
	return GameManager.purchase_equipment(item_name, price)

func get_player_money() -> int:
	return GameManager.player_money

func end_interaction():
	if shop_ui:
		shop_ui.close_shop()
	print("Closed shop interface")