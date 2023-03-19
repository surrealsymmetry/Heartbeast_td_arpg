extends Node2D

var data = {}

@onready var label = $"Control/Label 1"
@onready var player = get_tree().get_root().get_node("World/Player")


# VIRTUAL FUNCTIONS#
####################
func _process(delta: float) -> void:
	data.merge( {"TEST: ": Util.random_char_string(8)}, true)
	data.merge( {"FPS: ": Engine.get_frames_per_second()}, true)

func _on_player_debug( dict: Dictionary ) -> void:
	data.merge( dict, true )
	update_label()


# MEMBER FUNCTIONS #
####################
func update_label():
	label.text = ""
	for key in data.keys():
		label.text += "\n%s:\t%s" % [key, data[key]]
