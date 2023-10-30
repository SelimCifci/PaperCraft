extends TileMap

@export var smoothness: int = 3
@export var width: int
@export var height: int

var noise = FastNoiseLite.new()

func _ready():
	noise.seed = randi_range(0, 1000000)
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_octaves = smoothness
	#-------------------------------------------
	for x in range(-width/2, width/2):
		var y = ceil(noise.get_noise_1d(x) * height)
		
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
		
		#Generate bedrock
		set_cell(0, Vector2i(x,height-1), 0, Tiles.coords["bedrock"])
