extends CharacterBody2D


signal moved_left
signal moved_right
signal landed
signal jumped
signal stopped
signal fell



@export var SPEED = 50
@export var JUMP_VELOCITY = -400
@export var SHORT_HOP_MODIFIER = 6
const APEX_JUMP_THRESHOLD = 10
const APEX_BONUS = 100
const MIN_FALL_SPEED = 800
const MAX_FALL_SPEED = 1000
@export var GROUND_FRICTION = 0.80
@export var COYOTE_TIME = 0.09
const MAX_SPEED = 200



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# var gravity = 100
var time_since_fall = 0
var saved_jump = false
var jumping = false
var falling = false
var moving = false
var facing = 1


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		facing = direction
	if is_on_floor() and (jumping or falling):
		jumping = false
		falling = false
		time_since_fall = 0
		emit_signal("landed")
	elif is_on_floor():
		time_since_fall = 0
	else:
		time_since_fall += delta
	
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
		emit_signal("jumped")
	elif Input.is_action_just_pressed("ui_accept") and time_since_fall < COYOTE_TIME:
		velocity.y = JUMP_VELOCITY
		jumping = true
		emit_signal("jumped")
	elif Input.is_action_just_pressed("ui_accept"):
		# Save jump
		saved_jump = true
	elif is_on_floor() and saved_jump:
		velocity.y = JUMP_VELOCITY
		jumping = true
		saved_jump = false
		emit_signal("jumped")
	
	# reset saved jump
	if Input.is_action_just_released("ui_accept"):
		saved_jump = false
		
	# _apexPoint = Mathf.InverseLerp(_jumpApexThreshold, 0, Mathf.ABs(velocity.y));
	var apex_point = inverse_lerp(500, 0, abs(velocity.y))
	
	# var apexBoost = Mathf.Sign(Input.X)* _apexBonus * _apex'Point;
	var apex_boost = direction * APEX_BONUS * apex_point
	
	
	#fallSpeed = Mathf.Lerp(_minFallSpeed, _maxFallSpeed, _apexPoint)
	gravity = lerpf(MIN_FALL_SPEED, MAX_FALL_SPEED, apex_point)
	
	#  Add the gravity and chec kfor short hop
	if Input.is_action_just_released("ui_accept") and not is_on_floor() and velocity.y < 0:
		velocity.y += gravity * delta * SHORT_HOP_MODIFIER
	if not is_on_floor():
		velocity.y += gravity * delta


	# Increases as you get closer to the apex
	

	
	# _currentHorizontalSpeed += apexBoots * Time.deltaTime;
	
	if direction > 0:
		velocity.x = min(velocity.x+SPEED, MAX_SPEED)
	elif direction < 0:
		velocity.x = max(velocity.x-SPEED, -MAX_SPEED)
	elif is_on_floor():
		velocity.x = lerpf(velocity.x, 0, 0.25)
	else:
		velocity.x = lerpf(velocity.x, 0, 0.04)
		
	if jumping:
		velocity.x += apex_boost
	
	if direction > 0 and not moving:
		moving = true
		emit_signal("moved_right")
	elif direction < 0 and not moving:
		moving = true
		emit_signal("moved_left")
	elif direction == 0 and moving:
		moving = false
		emit_signal("stopped")
	
	if is_on_floor():
		falling = false
	elif velocity.y > 0 and not falling and not is_on_floor():
		falling = true
		emit_signal("fell")
		
	

	move_and_slide()
