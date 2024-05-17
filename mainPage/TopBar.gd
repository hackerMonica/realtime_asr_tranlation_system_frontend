extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ffmpeg = {pid = -1,running = false}
var popup
# Called when the node enters the scene tree for the first time.
func _ready():
	popup = $HBoxContainer/SettingButton.get_popup()
	set_drag_forwarding(self)
	get_tree().root.set_transparent_background(true)
	popup.add_item("后端地址",0)
	popup.add_check_item("翻译",1)
	popup.add_item("ASR地址",2)
	popup.add_item("RUN FFMPEG",3)

	

	popup.set_item_checked(1,GlobalVar.translate)

	popup.connect("id_pressed",self,"_on_menu_item_selected")

var dragging = false
var drag_start = Vector2()
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				# 鼠标左键按下，开始拖动
				dragging = true
				drag_start = event.position
			else:
				# 鼠标左键释放，结束拖动
				dragging = false
	elif event is InputEventMouseMotion:
		if dragging:
			# 鼠标移动时，如果正在拖动，更新窗口位置
			var new_position = OS.get_window_position() + event.position - drag_start
			OS.set_window_position(new_position)


func _on_ExitButton_pressed():
	var config = ConfigFile.new()
	config.set_value("config","url",GlobalVar.http_url)
	config.set_value("config","translate",GlobalVar.translate)
	config.set_value("config","asr_url",GlobalVar.asr_url)
	config.save("user://config.save")
	if ffmpeg.running:
		OS.kill(ffmpeg.pid)
		ffmpeg.running = false
		print("kill ffmpeg pid: "+str(ffmpeg.pid))
	get_tree().quit()

signal start
func _on_StartButton_pressed():
	emit_signal("start")
	$HBoxContainer/StopButton.visible = true

signal stop
func _on_StopButton_pressed():
	$HBoxContainer/StopButton.visible = false
	emit_signal("stop")

signal info
func _on_InfoButton_pressed():
	emit_signal("info")

signal config
signal asr_config
func _on_menu_item_selected(id):
	match id:
		0:
			emit_signal("config")
		1:
			GlobalVar.translate = !GlobalVar.translate
			popup.set_item_checked(1,GlobalVar.translate)
			print(str(GlobalVar.translate))
			print(popup.is_item_checked(1))
			print("")
		2:
			print("ASR地址: "+GlobalVar.asr_url)
			emit_signal("asr_config")
		3:
			# OS.execute("ffmpeg",
			# ["-f dshow -i audio=\"virtual-audio-capturer\" -tune zerolatency -ac 1 -vn -ar 16000 -acodec pcm_s16le -rtbufsize 0M -f wav "
			# +GlobalVar.asr_url+" > D:\\codefield\\Godot\\nlp-realtime-translation\\output.txt"], false)
			
			#OS.execute("cmd", ["/c", "ffmpeg -f dshow -i audio=\"virtual-audio-capturer\" -tune zerolatency -ac 1 -vn -ar 16000 -acodec pcm_s16le -rtbufsize 0M -f wav " + GlobalVar.asr_url + " > D:\\codefield\\Godot\\nlp-realtime-translation\\output.txt"], false)
			if not ffmpeg.running:
				ffmpeg.pid = OS.execute("ffmpeg", [
					"-f", "dshow",
					"-i", "audio=\"virtual-audio-capturer\"",
					"-tune", "zerolatency",
					"-ac", "1",
					"-vn", "-ar", "16000",
					"-acodec", "pcm_s16le",
					"-rtbufsize", "0M",
					"-f", "wav", GlobalVar.asr_url], false)
				ffmpeg.running = true
				print("ffmpeg pid: "+str(ffmpeg.pid))
				popup.set_item_text(3,"STOP FFMPEG")
			else:
				OS.kill(ffmpeg.pid)
				ffmpeg.running = false
				print("kill ffmpeg pid: "+str(ffmpeg.pid))
				popup.set_item_text(3,"RUN FFMPEG")
