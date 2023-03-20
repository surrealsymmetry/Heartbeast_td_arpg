extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_meter(text, f):
	pass
#	var bg_color :Color = Color(0, 0, 0, 0.5)
#	var fg_color :Color = Color.RED.lerp(Color.GREEN, f)
#	var pad = 1
#	var w = 75
#
#	var line_count = label.get_line_count()
#	var line_height = label.get_line_height()
#	data.merge({"LINES: ": line_count}, true)
#
#	var x = label.position.x
#	var y = line_height * line_count
#
#	var meter_text_pos = Vector2(x, y)
#
#	var range :Vector2 = Vector2(0, 1)
#
#	draw_rect(
#		Rect2(
#			x, 
#			y, 
#			w, 
#			line_height
#		), 
#		bg_color 
#	)
#	draw_rect( 
#		Rect2(
#			x + pad, 
#			y + pad, 
#			w * f - pad * 2, 
#			line_height - pad * 2 
#		), 
#		fg_color
#	)
#
#	draw_string_outline(font, meter_text_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, 4, 2, Color.BLACK)
#	draw_string(font, meter_text_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, 4 )
