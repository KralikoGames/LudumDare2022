extends TileMap

const TileSprites = [Vector2i(0,1),Vector2i(1,0),Vector2i(0,0)]
var usedTiles = {}

func _ready():
	randomize()  
	usedTiles[Vector2(0,0)] = true;

	
	MakeStage(0)
#	for i in range(6):
#		MakeStage(i*100)
#		await get_tree().create_timer(10).timeout
	
func floodFill(startTile):
	var list = [startTile]
	var visited = {};
	
	while(list.size()>0):
		var current = list.pop_front()
		for neighbour in get_surrounding_tiles(current):
			if(!visited.has(neighbour)):
				visited[neighbour] = true;
				if(get_used_cells(0).has(neighbour)):
					return neighbour;
				else:
					list.append(neighbour)
					
func MakeBranch(endPos):
	var startPos = floodFill(endPos);
	var slope = endPos-startPos;
	var growPos = startPos;

	var posList = [];

	for i in range(abs(slope.x)):
		posList.append('x');		
	for i in range(abs(slope.y)):
		posList.append('y');

	posList.shuffle()
	var branchTiles = abs(slope.x)+abs(slope.y)
	var lastTile = Vector2i(0,0)
	for i in range(branchTiles):
		if(posList[i] == 'x'):
			growPos.x += sign(slope.x) 
		else:
			growPos.y += sign(slope.y) 
		for j in range(3):
			await get_tree().create_timer(((9.0/float(branchTiles))/3.0)).timeout
			var check = lastTile == Vector2i.ZERO or growPos == Vector2i.ZERO 
			if check and lastTile != growPos:
				var temp = Vector2i(growPos.x+1, growPos.y)
				set_cells_terrain_connect(0, [temp, growPos], 0, 0, true)
			elif lastTile != growPos:
				set_cells_terrain_connect(0, [lastTile, growPos], 0, 0, true)
			lastTile = growPos
				


func MakeLeaves(pos):
	MakeBranch(pos)
	await get_tree().create_timer(10).timeout
	
	var leafSize = randi()%6+2;
	var adjustPos = pos
	var branch_array = []
	for i in range(leafSize):
		adjustPos.x = pos.x-(leafSize/2) + i
		branch_array.append(adjustPos)
	print(branch_array)
	set_cells_terrain_connect(0, branch_array, 1, 0)

func MakeStage(height):
	# creates central mass of branches will crash if you remove because of flood fill
	var branch_array = []
	for i in range(3):
		for j in range(5):
			branch_array.append(Vector2i(i-2,-j+height))
	set_cells_terrain_connect(0, branch_array, 0, 0)
	
	# Does the growing
	for i in range(5):
		MakeLeaves(Vector2i(randi()%30-15,randi()%10-10))
