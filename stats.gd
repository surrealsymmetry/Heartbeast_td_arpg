extends Node

@export var max_health : int = 1

@onready var health = max_health: 
	set(i):
		health = i
		if health <= 0:
			emit_signal("no_health")
	get:
		return health

signal no_health
