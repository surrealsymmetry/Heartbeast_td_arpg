extends AnimatedSprite2D

var is_facing_left :bool  = false:
	set(v):
		is_facing_left = v


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flip_h = is_facing_left
	play("Animation")
	sprite_frames.set_animation_loop("Animation", false)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	if sprite_frames_changed:
#		print()
	pass

func _on_animation_looped() -> void:
	
	pass
