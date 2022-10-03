extends Area2D

func _ready():
	var type_roll = randi()%3
	if type_roll == 0:
		$AnimatedSprite2d.play("blue")
	elif type_roll == 1:
		$AnimatedSprite2d.play("red")
	else:
		$AnimatedSprite2d.play("yellow")
