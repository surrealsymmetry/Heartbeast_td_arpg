extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

var knockback = Vector2.ZERO

@onready var stats = $Stats

func _ready():
	print('bat spawned with %s / %s HP' % [stats.max_health, stats.health])
	
func _physics_process(delta: float) -> void:
	velocity= velocity.move_toward( Vector2.ZERO, 500 * delta )
	move_and_slide()
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	velocity = area.knockback_vector * 300


func _on_stats_no_health() -> void:	
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	queue_free()
