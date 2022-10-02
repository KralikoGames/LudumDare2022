@onready var parent_sprite: AnimatedSprite = get_parent() as AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	parent_sprite.connect("frame_changed",self,_on_framechanged)
	
func _on_framechanged
	if parent_sprite.frame = 0
		@play()




