extends Area2D

var eatten = false

func _ready():
	set_meta("object", "chungus")

func _eat():
	print("TEST")
	if not eatten:
		eatten = true
		$Eat.play()
		await get_tree().create_timer(0.3).timeout
		queue_free()

func _del():
	queue_free()
