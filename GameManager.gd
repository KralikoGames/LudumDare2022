extends Node2D


# Listen for player eatting chungus
# Clear tiles and fruit
# Spawn title screen
# Trigger new Growth
signal clear_bushes

@onready var title_card = preload("res://Scenes/Title.tscn")


func _ready():
	# Setup
	$Player.game_over.connect(_on_game_over)
	
	
	# Start out
	await get_tree().create_timer(1).timeout
	
	# Falling
	emit_signal("clear_bushes")
	$AlexFullGrowth.clear_cells()
	await get_tree().create_timer(3).timeout
	
	# Tile Card
	$Fruit._del()
	var thing = title_card.instantiate()
	get_parent().call_deferred("add_child", thing)
	thing.global_position = $Camera.global_position
	await get_tree().create_timer(3).timeout
	
	# Growing
	$AlexFullGrowth.grow_tree()
	$Track1.play()

func _on_game_over():
	# Start out
	await get_tree().create_timer(1).timeout
	
	# Falling
	emit_signal("clear_bushes")
	$AlexFullGrowth.clear_cells()
	await get_tree().create_timer(3).timeout
	
	# Tile Card
	var thing = title_card.instantiate()
	get_parent().call_deferred("add_child", thing)
	thing.global_position = $Camera.global_position
	await get_tree().create_timer(3).timeout
	
	# Growing
	$AlexFullGrowth.grow_tree()
	$Track1.play()
