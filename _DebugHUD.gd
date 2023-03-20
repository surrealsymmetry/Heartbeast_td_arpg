extends Node2D

var data = {}

@onready var label = $"Control/Label 1"
@onready var player = get_tree().get_root().get_node("World/Player")


# VIRTUAL FUNCTIONS#
####################
func _process(delta: float) -> void:
	data.merge( {
			"FPS: ": Engine.get_frames_per_second(),
#			"TEST: ": Util.random_char_string(8),
		}, true
	)
	
func _draw() -> void:
	print("drawing : " + Util.random_letter_string(12))
	draw_meter(10, 20, 40, 50)
	
func _on_player_debug( dict: Dictionary ) -> void:
	data.merge( dict, true )
	update_label()
	
# MEMBER FUNCTIONS #
####################
func update_label():
	label.text = ""
	var sorted_keys = data.keys()
	sorted_keys.sort()
	for key in sorted_keys:
		label.text += "\n%s:\t%s" % [key, data[key]]


func draw_meter(x, y, w, h):
	draw_rect( Rect2(Vector2(x, y), Vector2(w, h)), Color.SLATE_GRAY)
