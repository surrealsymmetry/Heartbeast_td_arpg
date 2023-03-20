extends Node2D

var data = {}


@onready var label : Node = $"Control/Label 1"
@onready var player : CharacterBody2D = get_tree().get_root().get_node("World/Player")

@export var font : Font

# VIRTUAL FUNCTIONS#
####################
func _process(delta: float) -> void:
	data.merge( {
			"FPS: ": Engine.get_frames_per_second(),
#			"TEST: ": Util.random_char_string(8),
		}, true
	)
	
	test_label_adding( delta )
	queue_redraw()
	
func _draw() -> void:
	draw_meter("test meter", Util.random_float_normal())
	
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


func draw_meter(text, f):
	var bg_color :Color = Color(0, 0, 0, 0.5)
	var fg_color :Color = Color.RED.lerp(Color.GREEN, f)
	var pad = 1
	var w = 75
	
	var line_count = label.get_line_count()
	var line_height = label.get_line_height()
	data.merge({"LINES: ": line_count}, true)
	
	var x = label.position.x
	var y = line_height * line_count
	
	var meter_text_pos = Vector2(x, y)
	
	var range :Vector2 = Vector2(0, 1)

	draw_rect(
		Rect2(
			x, 
			y, 
			w, 
			line_height
		), 
		bg_color 
	)
	draw_rect( 
		Rect2(
			x + pad, 
			y + pad, 
			w * f - pad * 2, 
			line_height - pad * 2 
		), 
		fg_color
	)
	
	draw_string_outline(font, meter_text_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, 4, 2, Color.BLACK)
	draw_string(font, meter_text_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, 4 )
	
var _time_since_new_label :float = 0
func test_label_adding(delta):
	_time_since_new_label += delta
	if _time_since_new_label > 3:
		data.merge({Util.random_digit(): "placeholder garbage " + Util.random_char_string(4)}, true)
		_time_since_new_label = 0
