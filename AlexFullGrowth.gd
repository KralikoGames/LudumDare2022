extends Node2D

const BRANCH_OFFSET = 3
const GROW_CYCLES = 10
const BRANCH_NUMBER = 4
const LEAF_SPACING = 5
const GROW_PHASES = 4

func _ready():
	var height_offset = (LEAF_SPACING-2)*BRANCH_NUMBER
	for i in range(GROW_PHASES):
		randomize()
		run_grow(-1*height_offset*i)
		await get_tree().create_timer(10).timeout

func run_grow(base_height):
	# Add starting node for each branch
	var branch_tiles = []
	var grow_direction = []
	var grow_wait = float(10)/GROW_CYCLES/BRANCH_NUMBER
	print(grow_wait)
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
			await get_tree().create_timer(grow_wait).timeout
	
	# Grow Leaves
	for branch in range(0, len(branch_tiles)):
		for cell in range(LEAF_SPACING - 1, GROW_CYCLES, LEAF_SPACING):
			var platform_location = branch_tiles[branch][cell]
			var platform_size = randi()%3 + 2 # between 2 and 4
			var platform_array = [platform_location]
			for i in range(-platform_size/2, platform_size/2, 1):
				platform_array.append(Vector2i(platform_location.x + i, platform_location.y))
			$AlexLeaves.set_cells_terrain_connect(0, platform_array, 1, 0)
	
	
	
