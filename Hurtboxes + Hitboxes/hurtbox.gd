extends Area2D

const HitEffect = preload("res://Effects/hit_effect.tscn")

@onready var timer = $Timer
signal invincibility_started
signal invincibility_ended

var invincible = false :
	set (value):
		invincible = value
		if invincible == true:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")

func start_invincibility(duration):
	timer.start(duration)
	self.invincible = true
	
func create_hit_effect() -> void:
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_timer_timeout() -> void:
	self.invincible = false # calling SETTER rather than direct access


func _on_invincibility_ended() -> void:
	monitorable = true
	
func _on_invincibility_started() -> void:
	set_deferred("monitorable", false)
