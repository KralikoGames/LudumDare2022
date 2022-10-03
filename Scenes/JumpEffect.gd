extends AnimatedSprite2D

func _ready():
	play("jump")
	print("enod")

func animation_finished():
	print("done")
	queue_free()
