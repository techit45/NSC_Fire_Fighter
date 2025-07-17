extends Node2D

# Node references
@onready var player = $Player
@onready var win_label = $CanvasLayer/WinLabel
@onready var lose_label = $CanvasLayer/LoseLabel
@onready var health_label = $CanvasLayer/HealthLabel
@onready var station_transition = $StationTransition

var game_ended = false

func _ready():
	setup_fire_signals()
	
	# Connect station transition
	if station_transition:
		station_transition.area_entered.connect(_on_station_transition_entered)
	
	print("Mission Level initialized with ", get_tree().get_nodes_in_group("Fires").size(), " fires")

func _process(_delta):
	if not game_ended:
		# Update health display
		health_label.text = "Health: " + str(player.health)
		
		# Check win/lose conditions
		check_win_condition()
		check_lose_condition()

func setup_fire_signals():
	# Connect all fire damage signals to player
	var fires = get_tree().get_nodes_in_group("Fires")
	for fire in fires:
		if not fire.on_damage_player.is_connected(player.take_damage):
			fire.on_damage_player.connect(player.take_damage)
			print("Connected fire signal: ", fire.name)

func check_win_condition():
	# Check if all fires are extinguished
	var remaining_fires = get_tree().get_nodes_in_group("Fires")
	if remaining_fires.size() == 0:
		game_ended = true
		win_label.visible = true
		
		# Complete mission in GameManager
		GameManager.complete_mission(true)
		
		# Show station transition after win - move to center of screen
		if station_transition:
			station_transition.visible = true
			station_transition.position = Vector2(400, 300)  # Center position
			
		# Also show instruction on win label
		win_label.text = "MISSION COMPLETE!\nWalk to EXIT to return to station"
		print("MISSION COMPLETE! All fires extinguished!")

func check_lose_condition():
	# Check if player health is depleted
	if player.health <= 0:
		game_ended = true
		lose_label.visible = true
		get_tree().paused = true
		print("MISSION FAILED! Player health depleted!")

func _on_station_transition_entered(area):
	if area == player.interaction_area and game_ended and remaining_fires_count() == 0:
		print("Returning to Fire Station")
		GameManager.advance_story_progress()
		get_tree().paused = false
		GameManager.change_scene(GameManager.FIRE_STATION_SCENE)

func remaining_fires_count() -> int:
	return get_tree().get_nodes_in_group("Fires").size()