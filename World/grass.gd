extends Node2D

const GrassEffect = preload("res://Effects/grass_effect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position #<---- this CONTEXT, aka the grass



func _on_hurtbox_area_entered( _area ) -> void:
	create_grass_effect()
	queue_free()
