extends AnimatedSprite2D

@onready var player: CharacterBody2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	player.jumped.connect(_on_jumped)
	player.moved_left.connect(_on_moved_left)
	player.moved_right.connect(_on_moved_right)
	player.landed.connect(_on_landed)
	player.stopped.connect(_on_stopped)
	player.fell.connect(_on_fell)

func _process(delta):
	flip_h = player.facing < 0

func _on_jumped():
	play("air_up")

func _on_moved_left():
	play("run")
	
func _on_moved_right():
	play("run")
	
func _on_landed():
	play("land")
	
func _on_stopped():
	play("idle")
	
func _on_fell():
	play("air_down")
