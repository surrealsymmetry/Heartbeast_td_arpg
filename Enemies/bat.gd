extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@export var ACCELERATION = 300
@export var MAX_SPEED = 500
@export var FRICTION = 700


enum{
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE
var knockback = Vector2.ZERO

@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var sprite = $AnimatedSprite
@onready var hurtbox = $Hurtbox


# VIRTUAL FUNCTIONS #
#####################
func _ready():
	print('bat spawned with %s / %s HP' % [stats.max_health, stats.health])
	
		
func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			velocity = velocity.move_toward( Vector2.ZERO, FRICTION * delta )
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var dir = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
				
	move_and_slide()

## signals	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	velocity = area.knockback_vector * 300
	hurtbox.create_hit_effect()
	
func _on_stats_no_health() -> void:	
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	queue_free()

# MEMBER FUNCTIONS #
####################
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	



