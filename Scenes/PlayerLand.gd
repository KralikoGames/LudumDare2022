extends AudioStreamPlayer2D


@onready var player: CharacterBody2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	player.landed.connect(_on_landed)

func _on_landed():
	play()
