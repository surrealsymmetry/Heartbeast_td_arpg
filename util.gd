extends Node

var rng = RandomNumberGenerator.new()



func xplor( obj, filter="", terse=true ):
	for property_dict in obj.get_property_list( ):
		var keys = property_dict.keys( )
		var property_name = property_dict[keys.pop_front( )]
		var rejected = filter.length() != 0 and !property_name.to_lower().contains(filter.to_lower())
		
		if not rejected: print( property_name )	
		if not terse and not rejected:
			for key in keys:
				print( "\t%-15s:\t%s" % [key, property_dict[key]] )
#			print("\n")

# RANDOM DATA #
###############
func random_float_normal():
	return rng.randf()
	
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
	return result
	
func random_v2_normal() -> Vector2:
	var x = randf_range(-1, 1)
	var y = randf_range(-1, 1)
	
	var result = Vector2(x, y).normalized()
	return result
	
func random_color_set( steps=0 ) -> Array:
	var base_color = randf()
	var delta = randf_range( 0.35, 0.65 ) #cheap hack to give it direction
	if coinflip(): delta *= -1
	var target_color = base_color + delta
		
	var hue_series = [Color.from_hsv(base_color, 1, 1, 1), Color.from_hsv(target_color, 1, 1, 1)]

	print( "\n\nnew hue series....\n%.3f to %.3f, \t %s steps " % [base_color, target_color, steps])
	
	if steps > 0:
		var travel_per_step :float = 1.0 / (steps + 1.0)
		for step in steps:
			var travel :float  = travel_per_step * (step + 1.0)	
			var f = lerp(base_color, target_color, travel)
			print("Step %s of %s\t\t+%.3f\n\tTravel:\t%.3f\n\tValue:\t%.3f" % [step, steps, travel_per_step, travel, f])
			
			hue_series.append(Color.from_hsv(f, 1, 1, 1))
	
#	print(hue_series)5555
	return hue_series
