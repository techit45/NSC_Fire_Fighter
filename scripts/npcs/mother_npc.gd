extends NPCBase

func _ready():
	super._ready()
	npc_name = "แม่"
	
	# Mother's dialogue
	dialogue_data = [
		{"speaker": "แม่", "text": "ลูกตื่นแล้วเหรอ? วันนี้ไปทำงานดับเพลิงอีกใช่มั้ย?"},
		{"speaker": "แม่", "text": "ระวังตัวด้วยนะลูก งานดับเพลิงมันอันตรายมาก"},
		{"speaker": "ผู้เล่น", "text": "ครับแม่ ผมจะระวังตัว ผมต้องไปสถานีแล้ว"},
		{"speaker": "แม่", "text": "ไปเถอะลูก แล้วกลับมาเล่าให้แม่ฟังนะ"},
		{"speaker": "แม่", "text": "อย่าลืมเรียนรู้เรื่องเครื่องมือดับเพลิงให้ดีด้วย!"}
	]
	
	can_repeat_dialogue = false

func on_dialogue_finished():
	super.on_dialogue_finished()
	
	# Advance story progress when talked to mother
	if GameManager.get_story_stage() == GameManager.StoryProgress.START_HOME:
		GameManager.advance_story_progress()
		print("Story advanced: Talked to Mother")