extends CharacterBody2D

var knockback = Vector2.ZERO

@onready var stats = $Stats

func _physics_process(delta: float) -> void:
	velocity= velocity.move_toward( Vector2.ZERO, 600 * delta )
	move_and_slide()
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	velocity = area.knockback_vector * 200
