extends CharacterBody2D

var knockback = Vector2.ZERO

@onready var stats = $Stats

func _ready():
	print(stats.max_health)
	print(stats.health)
	
func _physics_process(delta: float) -> void:
	velocity= velocity.move_toward( Vector2.ZERO, 500 * delta )
	move_and_slide()
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	velocity = area.knockback_vector * 300


func _on_stats_no_health() -> void:
	queue_free()
