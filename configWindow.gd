extends AcceptDialog
signal addEnter(name)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var button
# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/LineEdit.text = GlobalVar.http_url
	button = self.add_button("重置", 1,"reset")
	get_ok().text = "确定"
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AddDialog_confirmed():
	var text = $"%LineEdit".text
	GlobalVar.http_url = text



func _on_AddDialog_resized():
	print("resized")
	print("viewport size:"+str(get_viewport_rect().size))
	print("lineedit size:"+str($VBoxContainer/LineEdit.rect_size))
	#$LineEdit.rect_size.y = get_viewport_rect().size.y*0.4
	$VBoxContainer/LineEdit.rect_size.y = 20
	$VBoxContainer/LineEdit.rect_size.x = get_viewport_rect().size.x*0.9
	#$LineEdit.rect_position = get_viewport_rect().size/2 - $LineEdit.rect_size/2
	$VBoxContainer/LineEdit.rect_position.x = 100
	print("lineedit size:"+str($VBoxContainer/LineEdit.rect_size))


func _on_AddDialog_custom_action(action:String):
	if action == "reset":
		GlobalVar.http_url = GlobalVar.default_url
	$"VBoxContainer/LineEdit".text = GlobalVar.http_url
