extends Node2D

var data = {}
var text_offset : Vector2

@onready var label 	: Node = $"Control/Label 1"
@onready var player : CharacterBody2D = get_tree().get_root().get_node("World/Player")
@onready var meter_scene : PackedScene = load("res://UI/meter.tscn")

@onready var meters : Dictionary

# VIRTUAL FUNCTIONS#
####################
func _ready() -> void:
	meters.merge( {
			"random" : meter_scene.instantiate(),
			"hp" : meter_scene.instantiate(), 
			"speed" : meter_scene.instantiate(), 
		}, true
	)
	var demo_meter = meters["random"]
	demo_meter.set_demo(true)
	
	meters["hp"].style = meters["hp"].HIT_POINTS
	meters["speed"].style = meters["speed"].CYBER
	
	for v in meters.values():
		add_child(v)
		v.label = meters.find_key(v)
	
	_adjust_meters()

func _process(delta: float) -> void:
	data.merge( {
			"FPS" : Engine.get_frames_per_second(),
			"TEST": Util.random_char_string(8),
		}, true
	)
	
	meters["speed"].input = data["SPEED"]/200
	
	_test_label_adding( delta )
	queue_redraw()

# SIGNALLED
func _on_player_debug( dict: Dictionary ) -> void:
	data.merge( dict, true )
	update_label( )
	
# MEMBER FUNCTIONS #
####################
func update_label( ):
	label.text = ""
	var sorted_keys = data.keys()
	sorted_keys.sort()
	
	for key in sorted_keys:
		label.text += "\n%s:\t%s" % [key, data[key]]
	
	calculate_text_bottomleft()
	_adjust_meters()

func calculate_text_bottomleft():
	var y = label.get_line_count() * label.get_line_height()	
	var x = position.x
	text_offset = Vector2(x, y)
	return text_offset

var _time_since_new_label :float = 0
func _test_label_adding(delta):
	_time_since_new_label += delta
	if _time_since_new_label > 3:
		data.merge({"garbage_key--%s" % Util.random_digit(): Util.random_char_string(4)}, true)
		data.erase("garbage_key--%s" % Util.random_digit())
		_time_since_new_label = 0

func _adjust_meters():
	var p = text_offset
	for m in meters:
		meters[m].pos.y = p.y
		p.y += meters[m].size.y + 5
		meters[m].pos.x = position.x
		
