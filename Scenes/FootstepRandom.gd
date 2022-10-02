extends Node

@onready var parent_sprite: AnimatedSprite2D = get_parent()    
@onready var a = [1,2,3,4,5]
# Called when the node enters the scene tree for the first time.
func _ready():
	parent_sprite.frame_changed.connect(_on_framechanged)
	
func _on_framechanged():
	randomize()
	a.shuffle()
	print(parent_sprite.frame)
	var chos = a[0]
	if parent_sprite.animation == "run" and (parent_sprite.frame == 0 or parent_sprite.frame == 3):
		if chos == 1:
			$FS1.play()
		elif chos == 2:
			$FS2.play()
		elif chos == 3:
			$FS3.play()
		elif chos == 4:
			$FS4.play()
		elif chos == 5:
			$FS5.play()
