extends Node2D
var startup_garbage = 5
var data = {'a': 0}
var rng = RandomNumberGenerator.new()

@onready var label = $"Control/Label 1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(startup_garbage):
		data.merge({char(i + 65).to_lower(): random_char_string(8)}, true)	
	update_label()	

#func _process(delta: float) -> void:
#	pass

func update_label():
	for key in data.keys():
		label.text += "\n%s:\t%s" % [key, data[key]]
		
func random_digit(length=1):
	var result :int
	for i in range(length):
		result += rng.randi_range(0,9) * pow(10, i)
#		print(str(i) + ", " + str(result))
	return result

func random_letter_string(length=1):
	var result :String
	for i in range(length):
		var _char :String = char(randi_range(0, 25) + 65)
		if coinflip():
			_char = _char.to_lower()
		result += _char
	return result

func random_char_string(length=1):
	var result :String
	for i in range(length):
		if coinflip():
			result += str(random_digit())
		else:
			result += random_letter_string()
	return result

func coinflip():
	var result = (randi_range(0,1) == 1)
#	if result:
#		print("HEADs")
#	else:
#		print("TAILs")
	return result
