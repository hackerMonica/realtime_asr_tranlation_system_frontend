extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVar.connect("sentences_received", self, "_on_sentences_received")
	GlobalVar.connect("translations_received", self, "_on_translations_received")

	#$WindowDialog.dialog_text = "test"
	get_tree().root.set_transparent_background(true)
	

func _on_sentences_received(sentences):
	$RichTextLabel.text = sentences
	pass

func _on_translations_received(translations):
	$RichTextLabel.text = translations
	pass



func _on_TopBar_start():
	$Timer.start(0.1)
	$RichTextLabel.visible = true


func _on_TopBar_stop():
	$Timer.stop()
	$RichTextLabel.text = ""
	$RichTextLabel.visible = false


func _on_Timer_timeout():
	# print("timeout")
	if GlobalVar.translate:
		GlobalVar.get_translations()
	else:
		GlobalVar.get_sentences()


func _on_TopBar_info():
	$WindowDialog.visible = true
	$WindowDialog.rect_size = get_viewport_rect().size*0.6
	# 移动窗口到屏幕中央
	$WindowDialog.rect_position = Vector2((get_viewport_rect().size.x-$WindowDialog.rect_size.x)/2,(get_viewport_rect().size.y-$WindowDialog.rect_size.y)/2+10)


func _on_TopBar_config():
	$ConfigDialog/VBoxContainer/LineEdit.text = GlobalVar.http_url
	$ConfigDialog.rect_size.y = get_viewport_rect().size.y/2
	$ConfigDialog.rect_size.x = get_viewport_rect().size.x*0.4
	$ConfigDialog.rect_position = Vector2((get_viewport_rect().size.x-$ConfigDialog.rect_size.x)/2,(get_viewport_rect().size.y-$ConfigDialog.rect_size.y)/2+10)
	$ConfigDialog.visible = true


func _on_TopBar_asr_config():
	$AsrConfigDialog/VBoxContainer/LineEdit.text = GlobalVar.asr_url
	$AsrConfigDialog.rect_size.y = get_viewport_rect().size.y/2
	$AsrConfigDialog.rect_size.x = get_viewport_rect().size.x*0.4
	$AsrConfigDialog.rect_position = Vector2((get_viewport_rect().size.x-$AsrConfigDialog.rect_size.x)/2,(get_viewport_rect().size.y-$AsrConfigDialog.rect_size.y)/2+10)
	$AsrConfigDialog.visible = true
