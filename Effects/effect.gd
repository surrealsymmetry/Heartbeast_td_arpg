extends AnimatedSprite2D

func _ready() -> void:
	animation_looped.connect(_on_animation_looped)
	play("Animate")

func _on_animation_looped() -> void:
	queue_free() 
