extends Node2D

var parent :Node 
var test_value :float = Util.random_float_normal()

var pos :Vector2
var size :Vector2

var pad :Vector2 = Vector2(1, 1)

var bg_color :Color = Color(0, 0, 0, 0.65)
#var fg_color_low = Color.from_hsv(0.0, 1.0, 1.0, 1.0)
#var fg_color_high = Color.from_hsv(100.0, 1.0, 0.8, 1.0)
var hue :float
var gradient :Gradient

var font :Font = load("res://Fonts/XanhMono-Italic.otf")
var font_size :int = 4

var _decreasing :bool = false
var _cycles_per_second = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gradient = Gradient.new()
	
	gradient.set_color(0, Color.RED)
	gradient.set_color(1, Color.FOREST_GREEN)
	
	gradient.add_point(0.15, Color.RED)
	gradient.add_point(0.35, Color.ORANGE_RED)
	gradient.add_point(0.45, Color.DARK_ORANGE)
	gradient.add_point(0.75, Color.FOREST_GREEN)
	
	for i in range(0, gradient.get_point_count() - 1):
		print("%s: %s" % [i, gradient.get_color(i)])
	
	
	parent = get_parent()
	size = get_size()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	pos = parent.get_placement( )
	_test_range( delta )
	queue_redraw()

func _draw():
	draw_rect( Rect2(pos,size + pad), bg_color )
	draw_rect( Rect2(pos + pad, Vector2(size.x * test_value,  size.y) - pad),  gradient.sample(test_value))
	
	draw_string_outline( font, pos, "example", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, 2, Color.BLACK )	
	draw_string( font, pos, "example", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size )

func get_size() -> Vector2:
	var h = font.get_height(font_size)
	return Vector2(30, h - pad.y)

func _test_range( delta ) -> void:
	if not _decreasing:
		test_value += _cycles_per_second * delta
	else:
		test_value -= _cycles_per_second * delta
	if test_value <= 0.0:
		_decreasing = false
	if test_value >= 1.0:
		_decreasing = true
