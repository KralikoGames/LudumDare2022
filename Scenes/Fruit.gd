extends Area2D

func _ready():
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
