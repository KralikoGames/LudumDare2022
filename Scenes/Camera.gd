extends Camera2D



const CAMERA_SPEED = 0.04

@onready var player: CharacterBody2D = get_parent().get_node("Player")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var smoothed_position = lerp(position, player.position, CAMERA_SPEED)
	position.y = clamp(smoothed_position.y - 1.5, -800, 260)
	position.x = smoothed_position.x
