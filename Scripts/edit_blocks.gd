extends Node2D

onready var tilemap = $Terrain
export var raycast_collision = Vector2.ZERO

var entity_in = false

func _physics_process(_delta):
	raycast_collision = tilemap.world_to_map($Player/RayCast2D.get_collision_point() - $Player/RayCast2D.get_collision_normal() * 8)
	
	var tile = tilemap.get_cellv(raycast_collision)
	var selected_item = $Player/Hotbar.items[$Player/Hotbar.selected_slot]
	
	if Input.is_action_just_pressed("build") and can_place(raycast_collision):
		tilemap.set_cellv(raycast_collision + $Player/RayCast2D.get_collision_normal(), selected_item[0])
		selected_item[1] -= 1
	elif Input.is_action_just_pressed("destroy") and tile != TileMap.INVALID_CELL and tile != 3:
		give_item(tile)
		tilemap.set_cellv(raycast_collision, TileMap.INVALID_CELL)
			
func can_place(pos):
	var can_place = false

	if $Player/Hotbar.items[$Player/Hotbar.selected_slot][1] >= 1 and tilemap.get_cellv(pos + $Player/RayCast2D.get_collision_normal()) == TileMap.INVALID_CELL:
		can_place = true
		
	if entity_in:
		can_place = false

	return can_place
	
func give_item(tile):
	for i in range(len($Player/Hotbar.items)):
		var item = $Player/Hotbar.items[i]
		if item[0] == tile and item[1] < 64:
			item[1] += 1
			break
		elif item[0] == -1:
			item[0] = tile
			item[1] += 1
			break
