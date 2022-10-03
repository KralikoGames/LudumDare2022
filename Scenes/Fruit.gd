extends Area2D

var eaten = false

@onready var eat_effect = preload("res://Scenes/EatEffect.tscn")

func _ready():
	get_parent().clear_bushes.connect(_on_game_over)
	$Grow.play()
	
	set_meta("object", "fruit")
	var type_roll = randi()%3
	if type_roll == 0:
		set_meta("type", "blue")
		$AnimatedSprite2d.play("blue")
	elif type_roll == 1:
		set_meta("type", "red")
		$AnimatedSprite2d.play("red")
	else:
		set_meta("type", "yellow")
		$AnimatedSprite2d.play("yellow")

func _eat():
	$AnimatedSprite2d.play("picked")
	if not eaten:
		$Eat.play()
		eaten = true
		var thing = eat_effect.instantiate()
		get_parent().get_parent().add_child(thing)
		thing.global_position = global_position

func _on_game_over():
	queue_free()
