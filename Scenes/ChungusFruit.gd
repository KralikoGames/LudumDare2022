extends Area2D

func _ready():
	set_meta("object", "chungus")

func _eat():
	queue_free()
