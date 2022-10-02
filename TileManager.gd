extends TileMap

const TileSprites = [Vector2i(0,1),Vector2i(1,0),Vector2i(0,0)]
var usedTiles = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	set_cell(0,Vector2(0,0),1,Vector2i(0,0))
	#set_cell(0,Vector2(2,0),1,Vector2i(0,0))
	usedTiles[Vector2(0,0)] = true;
	#get_surrounding_tiles(Vector2(0,0)
	MakeLeaves(Vector2i(-7,-8))

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
					
func MakeBranch(endPos):
	var startPos = floodFill(endPos);
	var slope = endPos-startPos;
	var growPos = startPos;
	
	print(slope);
	var posList = [];
	
	for i in range(abs(slope.x)):
		posList.append('x');		
	for i in range(abs(slope.y)):
		posList.append('y');
		
	posList.shuffle()
	var branchTiles = abs(slope.x)+abs(slope.y)
	for i in range(branchTiles):
		print(branchTiles);
		if(posList[i] == 'x'):
			growPos.x += sign(slope.x) 
			
		else:
			growPos.y += sign(slope.y) 
		for j in range(3):
			await get_tree().create_timer(.33).timeout
			set_cell(0,growPos,1,TileSprites[j])
			
func MakeLeaves(pos):
	MakeBranch(pos)
	await get_tree().create_timer(10).timeout
	set_cell(0,pos,1,Vector2i(1,1))
			
