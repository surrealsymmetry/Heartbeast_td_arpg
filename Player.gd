extends CharacterBody2D

const ACCELERATION = 500
const MAX_SPEED = 130 #80
const ROLL_SPEED = 180
const FRICTION = 460

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.DOWN

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")



# VIRTUAL FUNCTIONS #
#####################
func _ready():
	animationTree.active = true
	xplor(animationTree)
	
	
		
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
		animationTree.set("parameters/idle/blend_position", input_vector)
		animationTree.set("parameters/run/blend_position", input_vector)
		animationTree.set("parameters/attack/blend_position", input_vector)
		animationTree.set("parameters/roll/blend_position", input_vector)
		animationState.travel("run")
		velocity = velocity.move_toward( input_vector * MAX_SPEED, ACCELERATION * delta )
	else:
		animationState.travel("idle")
		velocity = velocity.move_toward( Vector2.ZERO, FRICTION * delta )
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func move():
	move_and_slide( )
	
func roll_state( delta ):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("roll")
	move()
	
func attack_state( delta ):
	velocity = Vector2.ZERO
	animationState.travel("attack")
	
func roll_animation_finished():
	velocity = velocity * 0.5
	state = MOVE
#
func attack_animation_finished():
	state = MOVE
	
	
# UTILITY FUNCTIONS #
#####################
func xplor(obj, terse=true):
	for property_dict in obj.get_property_list( ):
		var keys = property_dict.keys( )
		var front_key = keys.pop_front( )
		print( property_dict[front_key] )
		if !terse:
			for key in keys:
				print( "\t%-15s:\t%s" % [key, property_dict[key]] )
			print("\n\n")
