@onready var parent_sprite: AnimatedSprite = get_parent() as AnimatedSprite2D
@onready var a = [1,2,3,4,5]
# Called when the node enters the scene tree for the first time.
func _ready():
	parent_sprite.connect("frame_changed",self,_on_framechanged)
	
func _on_framechanged():
	if parent_sprite.frame == 0 or parent_sprite.frame == 3:
		if a.shuffle == 1:
			$FS1.play()
		elsif a.shuffle = 2:
			$FS2.play()
		elsif a.shuffle = 3:
			$FS3.play()
		elsif a.shuffle = 4:
			$FS4.play()
		elsif a.shuffle = 5:
			$FS5.play()
