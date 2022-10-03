extends TileMap

const HEIGHT_OFFSET = 100
const BRANCH_OFFSET = 2
const GROW_CYCLES = 10
const BRANCH_NUMBER = 4
const LEAF_SPACING = 4

var current_height = 0
var branch_tiles = []
var grow_direction = []

func _ready():
	randomize()
	run_grow()

func run_grow():
	# Add starting node for each branch
	for branch in range(BRANCH_NUMBER):
		var root_cell = Vector2i(0, current_height - BRANCH_OFFSET*branch)
		branch_tiles.append([root_cell])
		if branch%2:
			grow_direction.append("left")
			print("left")
		else:
			grow_direction.append("right")
			print("right")
		
	# Grow branches
	for cycle in range(GROW_CYCLES):
		for branch in range(BRANCH_NUMBER):
			
			#Choose grow direction
			var change_y = 0
			var change_x = 0
			var grow_up = not randi()%3
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
			set_cells_terrain_connect(0, branch_tiles[branch], 0, 0)
			await get_tree().create_timer(0.2).timeout
	
	# Grow Leaves
#	for branch in 

	
	
	
