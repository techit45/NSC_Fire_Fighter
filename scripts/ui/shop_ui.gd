extends Control
class_name ShopUI

# UI elements
@onready var shop_panel = $ShopPanel
@onready var item_list = $ShopPanel/VBoxContainer/ScrollContainer/ItemList
@onready var money_label = $ShopPanel/VBoxContainer/MoneyLabel
@onready var close_button = $ShopPanel/VBoxContainer/CloseButton
@onready var buy_button = $ShopPanel/VBoxContainer/HBoxContainer/BuyButton
@onready var item_description = $ShopPanel/VBoxContainer/DescriptionLabel

# Shop data
var current_items: Array = []
var selected_item_index: int = -1
var terminal_reference = null

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Connect signals
	if close_button:
		close_button.pressed.connect(close_shop)
	if buy_button:
		buy_button.pressed.connect(purchase_selected_item)
	if item_list:
		item_list.item_selected.connect(_on_item_selected)
	
	print("Shop UI initialized")

func open_shop(items: Array, terminal_ref = null):
	current_items = items
	terminal_reference = terminal_ref
	
	# Clear and populate item list
	if item_list:
		item_list.clear()
		for item in current_items:
			var display_text = "%s - %d บาท" % [item.description, item.price]
			item_list.add_item(display_text)
	
	# Update money display
	update_money_display()
	
	# Show shop
	visible = true
	get_tree().paused = true
	print("Shop opened with ", items.size(), " items")

func close_shop():
	visible = false
	get_tree().paused = false
	selected_item_index = -1
	print("Shop closed")

func _on_item_selected(index: int):
	selected_item_index = index
	if index >= 0 and index < current_items.size():
		var item = current_items[index]
		if item_description:
			item_description.text = item.description
		
		# Enable/disable buy button based on money
		if buy_button:
			buy_button.disabled = GameManager.player_money < item.price

func purchase_selected_item():
	if selected_item_index >= 0 and selected_item_index < current_items.size():
		var item = current_items[selected_item_index]
		
		if GameManager.purchase_equipment(item.name, item.price):
			print("Successfully purchased: ", item.name)
			update_money_display()
			
			# Update buy button state
			if buy_button:
				buy_button.disabled = GameManager.player_money < item.price
		else:
			print("Purchase failed for: ", item.name)

func update_money_display():
	if money_label:
		money_label.text = "เงิน: %d บาท" % GameManager.player_money

func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):
		close_shop()