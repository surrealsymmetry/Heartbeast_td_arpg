extends CharacterBody2D

@export var ACCELERATION 	= 500
@export var MAX_SPEED 		= 130
@export var ROLL_SPEED 		= 180
@export var FRICTION 		= 460

enum {
	MOVE,
	ROLL,
	ATTACK
}
  
var state = MOVE
var roll_vector = Vector2.DOWN
@export_range(0, 10) var attack_speed_mod: float = 2

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
#	xplor(animation_tree, "scAle")
	sword_hitbox.knockback_vector = roll_vector
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("_debugReset"):
		get_tree().reload_current_scene()

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
func move_state( delta ):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
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
		velocity = Vector2.ZERO
		velocity.move_toward(get_global_mouse_position(), delta * 300)
		state = ATTACK

func move():
	move_and_slide( )
	
func roll_state( delta ):
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("roll")
	move()
	
func attack_state( delta ):
	animation_state.travel("attack")
	move()
	
func roll_animation_finished():
	velocity = velocity * 0.5
	state = MOVE
#
func attack_animation_finished():
	state = MOVE
	
	
# UTILITY FUNCTIONS #
#####################
func xplor( obj, filter="", terse=true ):
	for property_dict in obj.get_property_list( ):
		var keys = property_dict.keys( )
		var property_name = property_dict[keys.pop_front( )]
		var rejected = filter.length() != 0 and !property_name.to_lower().contains(filter.to_lower())
		
		if not rejected: print( property_name )	
		if not terse and not rejected:
			for key in keys:
				print( "\t%-15s:\t%s" % [key, property_dict[key]] )
#			print("\n")
