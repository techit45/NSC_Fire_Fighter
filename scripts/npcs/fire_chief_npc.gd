extends NPCBase

func _ready():
	super._ready()
	npc_name = "หัวหน้าดับเพลิง"
	can_repeat_dialogue = false
	
	# Set dialogue based on story progress
	set_dialogue_for_current_stage()

func set_dialogue_for_current_stage():
	var story_stage = GameManager.get_story_stage()
	
	# First time meeting - tutorial dialogue
	if story_stage == GameManager.StoryProgress.AT_FIRE_STATION:
		dialogue_data = [
			{"speaker": "หัวหน้า", "text": "ยินดีต้อนรับสู่สถานีดับเพลิง! เธอพร้อมเรียนรู้เรื่องการดับเพลิงแล้วใช่มั้ย?"},
			{"speaker": "หัวหน้า", "text": "ไฟมี 3 ประเภทหลัก: Class A, Class B, และ Class C"},
			{"speaker": "หัวหน้า", "text": "Class A (ไฟไม้/กระดาษ) ใช้น้ำ (WATER)"},
			{"speaker": "หัวหน้า", "text": "Class B (ไฟน้ำมัน/เชื้อเพลิงเหลว) ใช้ผงเคมี (POWDER)"},
			{"speaker": "หัวหน้า", "text": "Class C (ไฟไฟฟ้า) ใช้ก๊าซ CO2"},
			{"speaker": "ผู้เล่น", "text": "เข้าใจแล้วครับ ใช้เครื่องมือที่เหมาะสมกับประเภทไฟ"},
			{"speaker": "หัวหน้า", "text": "ถูกต้อง! ตอนนี้เธอสามารถใช้ปุ่ม Q เพื่อเปลี่ยนเครื่องมือได้แล้ว"},
			{"speaker": "หัวหน้า", "text": "มีเหตุเพลิงไหม้หลายจุดในเมือง ไปขึ้นรถดับเพลิงเพื่อเริ่มภารกิจแรกเลย!"}
		]
		can_repeat_dialogue = false
	
	# After learning equipment - brief check-in
	elif story_stage == GameManager.StoryProgress.LEARNED_EQUIPMENT:
		dialogue_data = [
			{"speaker": "หัวหน้า", "text": "จำสิ่งที่สอนได้มั้ย? ใช้เครื่องมือที่เหมาะสมกับประเภทไฟ"},
			{"speaker": "หัวหน้า", "text": "ไปดูอุปกรณ์ที่โต๊ะเครื่องมือ แล้วขึ้นรถดับเพลิงเพื่อเริ่มภารกิจ!"}
		]
		can_repeat_dialogue = false
	
	# After first mission - congratulations
	elif story_stage >= GameManager.StoryProgress.FIRST_MISSION:
		var player_level = GameManager.player_level
		if player_level == 1:
			dialogue_data = [
				{"speaker": "หัวหน้า", "text": "ทำได้ดีมากสำหรับภารกิจแรก!"},
				{"speaker": "หัวหน้า", "text": "ลองดูแผนที่เพื่อเลือกภารกิจใหม่ หรือไปซื้ออุปกรณ์เพิ่มเติม"}
			]
		else:
			dialogue_data = [
				{"speaker": "หัวหน้า", "text": "เก่งขึ้นเรื่อยๆ! ระดับ " + str(player_level) + " แล้ว"},
				{"speaker": "หัวหน้า", "text": "มีภารกิจที่ยากขึ้นรอเธออยู่ ดูที่แผนที่เลย"}
			]
		can_repeat_dialogue = false

func start_interaction():
	# Update dialogue based on current story progress
	set_dialogue_for_current_stage()
	print("Fire Chief - Story Stage: ", GameManager.get_story_stage())
	print("Fire Chief - Has Talked: ", has_talked)
	print("Fire Chief - Can Repeat: ", can_repeat_dialogue)
	print("Fire Chief - Dialogue Count: ", dialogue_data.size())
	super.start_interaction()

func on_dialogue_finished():
	print("Fire Chief - Dialogue finished called")
	super.on_dialogue_finished()
	
	# Mark equipment tutorial as complete
	if not GameManager.is_tutorial_completed("equipment_tutorial"):
		GameManager.mark_tutorial_complete("equipment_tutorial")
		print("Fire Chief - Equipment tutorial marked complete")
		
		# Advance story progress when learned equipment
		if GameManager.get_story_stage() == GameManager.StoryProgress.AT_FIRE_STATION:
			GameManager.advance_story_progress()
			print("Story advanced: Learned Equipment")
	
	print("Fire Chief - Has talked now: ", has_talked)