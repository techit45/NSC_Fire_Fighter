extends Control
class_name PlayerStatsUI

# UI elements
@onready var level_label = $StatsContainer/LevelLabel
@onready var money_label = $StatsContainer/MoneyLabel
@onready var experience_label = $StatsContainer/ExperienceLabel
@onready var health_label = $StatsContainer/HealthLabel

func _ready():
	print("Player Stats UI initialized")

func _process(delta):
	update_stats_display()

func update_stats_display():
	var stats = GameManager.get_player_stats()
	
	if level_label:
		level_label.text = "ระดับ: %d" % stats.level
	
	if money_label:
		money_label.text = "เงิน: %d บาท" % stats.money
	
	if experience_label:
		experience_label.text = "EXP: %d/%d" % [stats.experience, stats.exp_to_next]
	
	if health_label:
		health_label.text = "พลังชีวิต: %d" % stats.health
