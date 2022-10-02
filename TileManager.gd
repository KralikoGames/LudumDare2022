extends TileMap

var usedTiles = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	set_cell(0,Vector2(-2,0),1,Vector2i(0,0))
	#set_cell(0,Vector2(2,0),1,Vector2i(0,0))
	usedTiles[Vector2(0,0)] = true;
	#get_surrounding_tiles(Vector2(0,0)
	branchMaker(Vector2i(3,3))

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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
					
func branchMaker(endPos):
	var startPos = floodFill(endPos);
	var slope = endPos-startPos;
	
	print(slope);
	#for i in range(slope.x):
	#	set_cell(0,Vector2(-2,0),1,Vector2i(0,0))
			
