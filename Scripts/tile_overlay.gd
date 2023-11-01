extends Node2D

@onready var tilemap: TileMap = get_parent().get_node("Terrain")
@onready var raycast: RayCast2D = get_parent().get_node("Player/RayCast2D")

func _process(_delta):
	var collision_point = raycast.get_collision_point()
	var collision_normal = raycast.get_collision_normal()
	
	var map_pos = tilemap.local_to_map(collision_point-collision_normal*8)
	
	transform.origin = tilemap.map_to_local(map_pos)
