extends CharacterBody2D


const SPEED = 80
const JUMP_VELOCITY = -100
const SHORT_HOP_MODIFIER = 10
const APEX_JUMP_THRESHOLD = 10
const APEX_BONUS = 1
const MIN_FALL_SPEED = 0
const MAX_FALL_SPEED = 0
const GROUND_FRICTION = 0.80

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 100


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#  Add the gravity and chec kfor short hop
	if Input.is_action_just_released("ui_accept") and not is_on_floor() and velocity.y < 0:
		velocity.y += gravity * delta * SHORT_HOP_MODIFIER
	if not is_on_floor():
		velocity.y += gravity * delta


	# Increases as you get closer to the apex
	var apex_point = inverse_lerp(0, 10, abs(velocity.y))

	var apex_bonus = direction * APEX_BONUS * apex_point
	print(apex_point)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x += direction * SPEED
	velocity.x*= GROUND_FRICTION
		
	

	move_and_slide()
