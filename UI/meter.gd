extends Node2D

enum {
	RANDOM,
	HIT_POINTS,
	CYBER, 
}

const WIDTH = 50

var style = RANDOM
var parent :Node 
var gradient :Gradient

var _demo_mode :bool = true
var _demo_input :float = randf()

var pos :Vector2
var size :Vector2
var label :String
var pad :Vector2 = Vector2(1, 1)

var bg_color :Color = Color(0, 0, 0, 0.65)

var font :Font = load("res://Fonts/XanhMono-Italic.otf")
var font_size :int = 4

var _decreasing :bool = false
var _cycles_per_second = randf_range(0.2, 2)

func _ready() -> void:
	size = get_size()
	gradient = new_gradient_from_preset()	
#	for p in gradient.get_point_count():
#		print("%s: %s" % [p, gradient.get_color(p)])
	
func _process(delta: float) -> void:	
	if _demo_mode:
		if not _decreasing:
			_demo_input += _cycles_per_second * delta
		else:
			_demo_input -= _cycles_per_second * delta
		
		if _demo_input <= 0.0:
			_decreasing = false
		if _demo_input >= 1.0:
			_decreasing = true
	queue_redraw()

func _draw():
	draw_rect( Rect2(pos,size + pad), bg_color )
	draw_rect( Rect2(pos + pad, Vector2(size.x * _demo_input,  size.y) - pad),  gradient.sample(_demo_input))
	
	draw_string_outline( font, pos, label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, 2, Color.BLACK )	
	draw_string( font, pos, label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size )

func get_size() -> Vector2:
	var h = font.get_height(font_size)
	return Vector2(WIDTH, h - pad.y)


func new_gradient_from_preset() -> Gradient:
	gradient = Gradient.new()
	match style:
		RANDOM:
			var colors :Array = Util.random_color_set(randi_range(3, 5))
			gradient.set_color(0, colors[0])
			gradient.set_color(1, colors[1])
			
			for i in range(colors.size() - 2):
				gradient.add_point(i / (colors.size() -2), colors[i+2])
				
		HIT_POINTS:
			gradient.set_color(0, 		Color.DARK_RED)
			gradient.set_color(1, 		Color.FOREST_GREEN)
			gradient.add_point(0.25, 	Color.RED)
			gradient.add_point(0.35, 	Color.ORANGE_RED)
			gradient.add_point(0.48, 	Color.ORANGE)
			gradient.add_point(0.5, 	Color.FLORAL_WHITE)
			gradient.add_point(0.51, 	Color.FOREST_GREEN)
			
		CYBER:
			gradient.set_color(0, 		Color.CYAN)
			gradient.set_color(1, 		Color.DEEP_PINK)
			gradient.add_point(0.25, 	Color.BLUE)
			gradient.add_point(0.48, 	Color.DARK_ORCHID)
	return gradient




