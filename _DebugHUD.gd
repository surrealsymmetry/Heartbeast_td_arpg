extends Node2D

var startup_garbage = 0
var data = {'a': 0}

var update = {}

@onready var label = $"Control/Label 1"
@onready var player = get_tree().get_root().get_node("World/Player")

#RenderingServer.global_shader_parameter_set("fx", true)
# VIRTUAL FUNCTIONS#
####################
func _on_player_debug_velocity(velocity) -> void:
	data.merge( {"vel X: ": "%4.0f" % velocity.x, "vel Y: ": "%4.0f" % velocity.y}, true)
	data.merge( {"TEST: ": Util.random_char_string(8)}, true)
	data.merge( {"FPS: ": Engine.get_frames_per_second()}, true)
	data.merge( {"FX:": RenderingServer.global_shader_parameter_get("fx")}, true)
	update_label()


# MEMBER FUNCTIONS #
####################
func update_label():
	label.text = ""
	for key in data.keys():
		label.text += "\n%s:\t%s" % [key, data[key]]

