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
