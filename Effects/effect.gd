extends AnimatedSprite2D

func _ready() -> void:
	animation_finished.connect(_on_animation_finished)
	
	if is_connected("animation_finished", _on_animation_finished):
		print('signal SET for animation_finished')
	else:
		print('signal FAILED to set')
	
	play("Animate")

func _on_animation_finished() -> void:
	print("this never executes")
	queue_free() 
