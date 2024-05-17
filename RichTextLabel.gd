extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var scroll
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	scroll = get_v_scroll()
	scroll.connect("value_changed", self, "_on_scroll_updated")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_scroll_updated(value):
#	print("breakpoint")
	if value + scroll.get_page() >= scroll.get_max():
		scroll_following = true
	else:
		scroll_following = false
