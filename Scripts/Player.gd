extends CharacterBody2D


@export var SPEED = 80
@export var JUMP_VELOCITY = -400
@export var SHORT_HOP_MODIFIER = 5
const APEX_JUMP_THRESHOLD = 10
const APEX_BONUS = 1
const MIN_FALL_SPEED = 0
const MAX_FALL_SPEED = 0
@export var GROUND_FRICTION = 0.80
@export var COYOTE_TIME = 0.09


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# var gravity = 100
var time_since_fall = 0
var saved_jump = false


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if is_on_floor():
		time_since_fall = 0
	else:
		time_since_fall += delta
	
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_accept") and time_since_fall < COYOTE_TIME:
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_accept"):
		# Save jump
		saved_jump = true
	elif is_on_floor() and saved_jump:
		velocity.y = JUMP_VELOCITY
		saved_jump = false
	
	# reset saved jump
	if Input.is_action_just_released("ui_accept"):
		saved_jump = false
		
		
		
	
	#  Add the gravity and chec kfor short hop
	if Input.is_action_just_released("ui_accept") and not is_on_floor() and velocity.y < 0:
		velocity.y += gravity * delta * SHORT_HOP_MODIFIER
	if not is_on_floor():
		velocity.y += gravity * delta


	# Increases as you get closer to the apex
	var apex_point = inverse_lerp(1000, 0, abs(velocity.y))

	var apex_bonus = APEX_BONUS * apex_point
	print(apex_bonus)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x += direction * SPEED
	velocity.x*= GROUND_FRICTION
		
	

	move_and_slide()
