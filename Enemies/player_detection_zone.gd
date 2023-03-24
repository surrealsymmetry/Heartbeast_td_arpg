extends Area2D

var player = null

func can_see_player():
	return player != null
	
func _on_body_entered(body: Node2D) -> void:
#	print('Bat spots player!')
	player = body
	
func _on_body_exited(body: Node2D) -> void:
#	print('Bat lost track of player.')
	player = null

