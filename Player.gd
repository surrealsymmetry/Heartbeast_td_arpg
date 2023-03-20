extends CharacterBody2D

@export var ACCELERATION 	= 500
@export var MAX_SPEED 		= 130
@export var ROLL_SPEED 		= 180
@export var FRICTION 		= 460
@export_range(0, 10) var attack_speed_mod: float = 2
@export_range(0, 10) var roll_speed_mod: float = 2

signal _debug

enum {
	MOVE,
	ROLL,
	ATTACK
}


var roll_vector = Vector2.DOWN
var state = MOVE

@onready var animation_player 	= $AnimationPlayer
@onready var animation_tree 	= $AnimationTree
@onready var animation_state 	= animation_tree.get("parameters/playback")
@onready var sword_hitbox	 	= $HitboxPivot/SwordHitbox


# VIRTUAL FUNCTIONS #
#####################
func _ready():
	animation_tree.active = true
	animation_tree.set("parameters/attack/0/TimeScale/scale", attack_speed_mod)
	animation_tree.set("parameters/attack/1/TimeScale/scale", attack_speed_mod)
	animation_tree.set("parameters/attack/2/TimeScale/scale", attack_speed_mod)
	animation_tree.set("parameters/attack/3/TimeScale/scale", attack_speed_mod)
	animation_tree.set("parameters/roll/0/TimeScale/scale", roll_speed_mod)
	animation_tree.set("parameters/roll/1/TimeScale/scale", roll_speed_mod)
	animation_tree.set("parameters/roll/2/TimeScale/scale", roll_speed_mod)
	animation_tree.set("parameters/roll/3/TimeScale/scale", roll_speed_mod)
	Util.xplor(animation_tree, "scAle")
	sword_hitbox.knockback_vector = roll_vector
	
	
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("_debugReset"):
		get_tree().reload_current_scene()
	
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
	
# UTILITY / DEBUG FUNCTIONS #
#############################

func _update_debug_info():
	var _debug_info = {
		"STATE": state,
		"SPEED": velocity.length(),
#		"TEST": Util.random_char_string(5)	
	}
#	print(Engine.get_frames_per_second(), " : ",  Util.random_char_string(500))
	_debug.emit(_debug_info)
