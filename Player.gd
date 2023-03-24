extends CharacterBody2D

const corpse :PackedScene = preload("res://corpse.tscn")

enum {
	MOVE,
	ROLL,
	ATTACK
}

signal _debug

var stats = PlayerStats
var roll_vector = Vector2.DOWN
var state = MOVE

@export var ACCELERATION 	= 500
@export var MAX_SPEED 		= 130
@export var ROLL_SPEED 		= 180
@export var FRICTION 		= 460
@export var INVULN_SEC 	= 1

@export_range(0, 10) var attack_speed_mod: float = 2
@export_range(0, 10) var roll_speed_mod: float = 2


@onready var animation_player 	= $AnimationPlayer
@onready var animation_tree 	= $AnimationTree
@onready var animation_state 	= animation_tree.get("parameters/playback")
@onready var sword_hitbox	 	= $HitboxPivot/SwordHitbox
@onready var hurtbox 			= $Hurtbox
# VIRTUAL FUNCTIONS #
#####################
func _ready():
#	Util.xplor(animation_tree)
#	Util.xplor(animation_player)	
	
	stats.no_health.connect(perish)
	
	stats.health = stats.max_health
	sword_hitbox.knockback_vector = roll_vector
	
	animation_tree.active = true
	animation_tree.set("parameters/attack/0/TimeScale/scale", attack_speed_mod)
	animation_tree.set("parameters/attack/1/TimeScale/scale", attack_speed_mod)
	animation_tree.set("parameters/attack/2/TimeScale/scale", attack_speed_mod)
	animation_tree.set("parameters/attack/3/TimeScale/scale", attack_speed_mod)
	animation_tree.set("parameters/roll/0/TimeScale/scale", roll_speed_mod)
	animation_tree.set("parameters/roll/1/TimeScale/scale", roll_speed_mod)
	animation_tree.set("parameters/roll/2/TimeScale/scale", roll_speed_mod)
	animation_tree.set("parameters/roll/3/TimeScale/scale", roll_speed_mod)
#	Util.xplor(animation_tree, "scAle")
	
	
	
		
func _process(delta: float) -> void:
	_update_debug_info()
	
#	{"VEL X: ": "%4.0f" % velocity.x, "VEL Y: ": "%4.0f" % velocity.y}  {"SPEED": velocity.length()}

func _physics_process( delta ):
	match state:
		MOVE:
			move_state( delta )
		ROLL:
			roll_state( delta )
		ATTACK:
			attack_state( delta )


func _on_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= 1
	hurtbox.start_invincibility(INVULN_SEC)
	hurtbox.create_hit_effect()


# MEMBER FUNCTIONS #
####################
#var _debug_input :Vector2 = Util.random_v2_normal()
func move_state( delta ):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
#	print(_debug_input)
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		
		animation_tree.set("parameters/idle/blend_position", 	input_vector)
		animation_tree.set("parameters/run/blend_position", 	input_vector)
		animation_tree.set("parameters/attack/blend_position", 	input_vector)
		animation_tree.set("parameters/roll/blend_position", 	input_vector)
		
		animation_state.travel("run")
		velocity = velocity.move_toward( input_vector * MAX_SPEED, ACCELERATION * delta )
	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward( Vector2.ZERO, FRICTION * delta )
	
	move()
	
	if Input.is_action_just_pressed("roll"):			
		state = ROLL
		
	if Input.is_action_just_pressed("attack"):
		velocity = roll_vector 
#		velocity.move_toward(get_global_mouse_position(), delta * 300)
		state = ATTACK

func move():
	move_and_slide( )
	
func roll_state( delta ):
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("roll")
	move()
	
func attack_state( delta ):
	velocity = roll_vector * ROLL_SPEED/3
	animation_state.travel("attack")
	move()
	
func roll_animation_finished():
	velocity = velocity * 0.5
	state = MOVE
#
func attack_animation_finished():
	state = MOVE

func perish():
	var main = get_tree().current_scene
	var spawned_body = corpse.instantiate()
	spawned_body.global_position = global_position
	spawned_body.is_facing_left = animation_tree.get("parameters/idle/blend_position").x < 0
		
	main.add_child(spawned_body)
	_update_debug_info()
	queue_free()
		
# UTILITY / DEBUG FUNCTIONS #
#############################
func _update_debug_info():
	var _debug_info = {
		"STATE": state,
		"SPEED": velocity.length(),
		"HP": stats.health,
		"INVULN": hurtbox.invincible
#		"TEST": Util.random_char_string(5)	5
	}
	_debug.emit(_debug_info)

