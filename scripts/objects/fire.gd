extends Area2D

# Signal for player damage
signal on_damage_player(damage_amount)

# Configurable properties
@export var fire_type: String = "CLASS_A"
@export var correct_tool: String = "WATER"
@export var health: int = 100

func _ready():
	print("Fire created - Type: ", fire_type, ", Correct tool: ", correct_tool, ", Health: ", health)

func take_damage(tool_used: String):
	print("Fire hit with: ", tool_used, " (Correct tool: ", correct_tool, ")")
	
	if tool_used == correct_tool:
		# Correct tool used - damage the fire
		health -= 25
		print("Fire damaged! Health: ", health)
		
		if health <= 0:
			print("Fire extinguished!")
			queue_free()
	else:
		# Wrong tool used - damage the player
		print("Wrong tool used! Player takes damage.")
		on_damage_player.emit(10)