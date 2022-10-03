extends AnimatedSprite2D


func _process(delta):
	await get_tree().create_timer(2).timeout
	queue_free()
