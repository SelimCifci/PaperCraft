extends TileMap

@export var smoothness: int = 3
@export var width: int
@export var height: int
@export var flatness: int
@export var cave_frequency: float = 0.03

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
			map_to_local(Vector2i(1,y-2))
		
		#Generate grass
		set_cell(0, Vector2i(x,y-1), 0, Tiles.coords["grass"])
		
		#Generate dirt
		for i in range(y,y+5):
			set_cell(0, Vector2i(x,i), 0, Tiles.coords["dirt"])
		
		#Generate stone
		for i in range(y+5,height):
			set_cell(0, Vector2i(x,i), 0, Tiles.coords["stone"])
		
		#Generate caves
		for i in range(y,height):
			var yy = noise.get_noise_2d(x,i)
			
			if abs(yy) < cave_frequency:
				set_cell(0, Vector2i(x,i+y))
		
		if randi_range(0,10) == 10:
			generate_structure(Structures.tree,x,y-1)
		
		#Generate bedrock
		set_cell(0, Vector2i(x,height-1), 0, Tiles.coords["bedrock"])
	
	#Save player from being stuck in spawn
	set_cell(0, Vector2i(1,0), 0, Tiles.coords["bedrock"])
	set_cell(0, Vector2i(1,-1))
	set_cell(0, Vector2i(1,-2))
	
func generate_structure(structure, x, y):
	for i in structure:
		if structure != Structures.tree:
			set_cell(0,Vector2(x,y)+i[0],0,i[1])
		else:
			if get_cell_atlas_coords(0,Vector2(x,y)+i[0]) != Tiles.coords["oak_log_leaf"] and get_cell_atlas_coords(0,Vector2(x,y)+i[0]) != Tiles.coords["oak_log"]:
				set_cell(0,Vector2(x,y)+i[0],0,i[1])
