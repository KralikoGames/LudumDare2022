extends AnimatedSprite2D

func _ready():
	play("jump")
	animation_finished.connect(_animation_finished)


func _animation_finished():
	queue_free()
