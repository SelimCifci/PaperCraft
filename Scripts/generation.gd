extends TileMap

@export var smoothness: int = 3
@export var width: int
@export var height: int
@export var flatness: int
@export var cave_frequency: float = 0.05

var noise = FastNoiseLite.new()

func _ready():
	noise.seed = randi_range(0, 999999)
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_octaves = smoothness
	#-------------------------------------------
	for x in range(-width/2, width/2):
		var y = ceil(noise.get_noise_1d(x) * flatness)
		
		if x == 0:
			get_parent().get_node("Player").transform.origin = \
			map_to_local(Vector2i(0,y-2))
		
		#Generate grass
		set_cell(0, Vector2i(x,y), 0, Tiles.coords["grass"])
		
		#Generate dirt
		for i in range(y+1,y+5):
			set_cell(0, Vector2i(x,i), 0, Tiles.coords["dirt"])
		
		#Generate stone
		for i in range(y+5,height):
			set_cell(0, Vector2i(x,i), 0, Tiles.coords["stone"])
		
		#Generate trees
		if randi_range(0,25) == 25:
			generate_structure(Structures.tree,x,y-1)
		
		#Generate caves
		for i in range(y,height):
			var yy = noise.get_noise_2d(x,i)
			
			if abs(yy) < cave_frequency:
				set_cell(0, Vector2i(x,i+y))
		
		#Generate bedrock
		set_cell(0, Vector2i(x,height-1), 0, Tiles.coords["bedrock"])
	
	#Save player from being stuck in spawn
	set_cell(0, Vector2i(0,-1), 0, Tiles.coords["bedrock"])
	set_cell(0, Vector2i(0,-2))
	set_cell(0, Vector2i(0,-3))
	
func generate_structure(structure, x, y):
	y+=1
	for i in structure:
		if structure != Structures.tree:
			set_cell(0,Vector2(x,y)+i[0],0,i[1])
		else:
			if get_cell_atlas_coords(0,Vector2(x,y)+i[0]) != Tiles.coords["oak_log_leaf"] and get_cell_atlas_coords(0,Vector2(x,y)+i[0]) != Tiles.coords["oak_log"]:
				set_cell(0,Vector2(x,y)+i[0],0,i[1])
