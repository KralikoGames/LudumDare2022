extends AudioStreamPlayer


@onready var player: CharacterBody2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	player.jumped.connect(_on_jumped)

func _on_jumped():
	play()
