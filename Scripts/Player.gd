extends CharacterBody2D

signal moved
signal landed
signal jumped
signal stopped
signal fell
signal soared
signal game_over

@export var SPEED = 10
@export var JUMP_VELOCITY = -350
@export var SHORT_HOP_MODIFIER = 6
const APEX_JUMP_THRESHOLD = 10
const APEX_BONUS = 15
const MIN_FALL_SPEED = 600
const MAX_FALL_SPEED = 800
@export var GROUND_FRICTION = 0.80
@export var COYOTE_TIME = 0.06
const MAX_SPEED = 200
const jump_stall_time = 0.06
const land_stall_time = 0.04

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var time_since_land = 0
var time_since_jump = 0
var time_since_fall = 0
var saved_jump = false
var jumping = false
var falling = false
var moving = false
var standing = false
var facing = 1
var jump_stall = false
var land_stall = false
var frozen = false
var frozen_time = 0

@onready var area_2d = $TEST

func _ready():
	area_2d.area_entered.connect(_on_enter)


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		facing = direction

	# Handling landing, falling, and cyote times
	if is_on_floor() and (jumping or falling):
		jumping = false
		falling = false
		land_stall = true
		emit_signal("landed")
	if velocity.y > 0 and not falling:
		falling = true
		emit_signal("fell")
	if is_on_floor():
		time_since_fall = 0
	else:
		time_since_fall += delta

	# Handle Jump.
	var coyote_check = time_since_fall < COYOTE_TIME and falling
	var jump_pressed = Input.is_action_just_pressed("ui_accept")
	var valid_jump_input = jump_pressed or saved_jump
	var valid_jump_situation = is_on_floor() or coyote_check
	var no_stalls = not land_stall and not jump_stall
	if  valid_jump_input and valid_jump_situation and no_stalls:
		saved_jump = false
		jump_stall = true
		emit_signal("jumped")
	elif Input.is_action_just_pressed("ui_accept"):
		saved_jump = true
	if Input.is_action_just_released("ui_accept"):
		saved_jump = false

	# Handling stalls
	if jump_stall:
		time_since_jump += delta
	if time_since_jump > jump_stall_time and jump_stall:
		velocity.y = JUMP_VELOCITY
		jump_stall = false
		time_since_jump = 0
		jumping = true
		emit_signal("soared")
	if land_stall:
		time_since_land += delta
	if time_since_land > land_stall_time and land_stall:
		land_stall = false
		time_since_land = 0

	# Handle in air boosts and modifiers
	var apex_point = inverse_lerp(500, 0, abs(velocity.y))
	var apex_boost = direction * APEX_BONUS * apex_point
	gravity = lerpf(MIN_FALL_SPEED, MAX_FALL_SPEED, apex_point)
	if Input.is_action_just_released("ui_accept") and not is_on_floor() and velocity.y < 0:
		velocity.y += gravity * delta * SHORT_HOP_MODIFIER
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle left and right movement
	if direction > 0 and no_stalls:
		velocity.x = min(velocity.x+SPEED, MAX_SPEED)
	elif direction < 0 and no_stalls:
		velocity.x = max(velocity.x-SPEED, -MAX_SPEED)
	elif is_on_floor():
		velocity.x = lerpf(velocity.x, 0, 0.25)
	else:
		velocity.x = lerpf(velocity.x, 0, 0.2)
	if jumping:
		velocity.x += apex_boost

	# Handling walking and idle animations
	if is_on_floor() and direction != 0 and not moving:
		moving = true
		emit_signal("moved")
	elif not is_on_floor() or direction == 0:
		moving = false
	if is_on_floor() and direction == 0 and no_stalls and not standing:
		standing = true
		emit_signal("stopped")
	if Input.is_action_just_pressed("ui_accept") or direction != 0:
		standing = false

	if frozen and frozen_time > 2:
		frozen = false
		velocity.y = 0
		velocity.x = 0
		frozen_time = 0
	elif frozen:
		frozen_time += delta
	else:
		move_and_slide()

func _on_enter(_body):
	var object = _body.get_meta("object")
	print(object)
	if object == "fruit":
		var type = _body.get_meta("type")
		print(type)
		_body._eat()
	if object == "chungus":
		_body._eat()
		frozen = true
		emit_signal("game_over")
