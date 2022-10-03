extends Node2D

const BRANCH_OFFSET = 3
const GROW_CYCLES = 10
const BRANCH_NUMBER = 4
const LEAF_SPACING = 5
const GROW_PHASES = 6
const FRUIT_CHANCE = 6

@onready var grow_pop = preload("res://Scenes/GrowPop.tscn")
@onready var fruit = preload("res://Scenes/Fruit.tscn")
@onready var chungus_fruit = preload("res://Scenes/ChungusFruit.tscn")

func _ready():
	grow_tree()


func grow_tree():
	var stage_wait = 10
	var height_offset = (LEAF_SPACING-2)*BRANCH_NUMBER
	for i in range(GROW_PHASES):
		randomize()
		run_grow_phase(-1*height_offset*i)
		await get_tree().create_timer(stage_wait).timeout
	# Grow Chungus
	await get_tree().create_timer(3).timeout
	grow_chungus()
	await get_tree().create_timer(3).timeout
	clear_cells()

func run_grow_phase(base_height):
	# Add starting node for each branch
	var branch_tiles = []
	var grow_direction = [] 
	var grow_wait = float(10)/GROW_CYCLES/BRANCH_NUMBER
	
	for branch in range(BRANCH_NUMBER):
		var root_cell = Vector2i(0, base_height - BRANCH_OFFSET*branch)
		branch_tiles.append([root_cell])
		if branch%2:
			grow_direction.append("left")
		else:
			grow_direction.append("right")
		
	# Grow branches
	for cycle in range(GROW_CYCLES):
		for branch in range(BRANCH_NUMBER):
			
			#Choose grow direction
			var change_y = 0
			var change_x = 0
			var grow_up = not randi()%4
			if grow_up:
				change_y = -1
			elif grow_direction[branch] == "left":
				change_x = -1
			else:
				change_x = 1
			
			# Update cells
			var last_cell = branch_tiles[branch][cycle]
			var new_cell = Vector2i(last_cell.x + change_x, last_cell.y + change_y)
			branch_tiles[branch].append(new_cell)
			
			# Grow branch and wait
			$AlexBranches.set_cells_terrain_connect(0, branch_tiles[branch], 0, 0)
			grow_effect(new_cell)
			await get_tree().create_timer(grow_wait).timeout
	
	# Grow Leaves
	for branch in range(0, len(branch_tiles)):
		for cell in range(LEAF_SPACING - 1, GROW_CYCLES, LEAF_SPACING):
			var platform_location = branch_tiles[branch][cell]
			var platform_size = randi()%3 + 2 # between 2 and 4
			var platform_array = [platform_location]
			grow_effect(platform_location)
			for i in range(-platform_size/2, platform_size/2, 1):
				var new_cell = Vector2i(platform_location.x + i, platform_location.y)
				platform_array.append(new_cell)
			$AlexLeaves.set_cells_terrain_connect(0, platform_array, 1, 0)
			
			# Add fruit
			var fruit_roll = not randi()%4
			if fruit_roll:
				var fruit_pos = Vector2i(platform_location.x, platform_location.y -1)
				grow_fruit(fruit_pos)

func clear_cells():
	var cells = $AlexBranches.get_used_cells(0)
	for cell in cells:
		$AlexBranches.erase_cell(0, cell)

	cells = $AlexLeaves.get_used_cells(0)
	for cell in cells:
		$AlexLeaves.erase_cell(0, cell)


func grow_effect(cell_position):
	var cell_size = $AlexBranches.cell_quadrant_size
	var local_tile_pos = $AlexBranches.map_to_local(cell_position)
	var global_tile_pos = to_global(local_tile_pos)
	var thing = grow_pop.instantiate()
	get_parent().call_deferred("add_child", thing)
	thing.global_position = global_tile_pos

func grow_fruit(cell_position):
	var cell_size = $AlexBranches.cell_quadrant_size
	var local_tile_pos = $AlexBranches.map_to_local(cell_position)
	var global_tile_pos = $AlexBranches.to_global(local_tile_pos)
	var thing = fruit.instantiate()
	get_parent().call_deferred("add_child", thing)
	global_tile_pos.x -= 7
	global_tile_pos.y -= 4
	thing.global_position = global_tile_pos

func grow_chungus():
	var chungs_location = Vector2(0,-832)
	var pop = grow_pop.instantiate()
	var fruit = chungus_fruit.instantiate()
	get_parent().call_deferred("add_child", pop)
	get_parent().call_deferred("add_child", fruit)
	pop.global_position = chungs_location
	fruit.global_position = chungs_location
	
	
