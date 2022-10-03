extends AnimatedSprite2D

@onready var player: CharacterBody2D = get_parent()
@onready var jump_effect = preload("res://Scenes/JumpEffect.tscn")
@onready var land_effect = preload("res://Scenes/LandEffect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.jumped.connect(_on_jumped)
	player.moved.connect(_on_moved)
	player.landed.connect(_on_landed)
	player.stopped.connect(_on_stopped)
	player.fell.connect(_on_fell)
	player.soared.connect(_on_soar)

func _process(delta):
	flip_h = player.facing < 0

func _on_jumped():
	play("jump")
	var dust = jump_effect.instantiate()
	get_parent().get_parent().add_child(dust)
	dust.global_position = global_position

func _on_moved():
	play("run")
	
func _on_landed():
	play("land")
	var dust = land_effect.instantiate()
	get_parent().get_parent().add_child(dust)
	dust.global_position = global_position

func _on_stopped():
	play("idle")
	
func _on_fell():
	play("air_down")

func _on_soar():
	play("air_up")
