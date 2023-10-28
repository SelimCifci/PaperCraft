extends Node2D

onready var tilemap = $Terrain

export var raycast_break = Vector2.ZERO

var entity_in = false

var selected_tile = Vector2(0, 0)

func _physics_process(_delta):
	var collision_point = $Player/RayCast2D.get_collision_point()
	var collision_normal = $Player/RayCast2D.get_collision_normal()
	raycast_break = tilemap.world_to_map(collision_point - collision_normal * 8)
	var raycast_build = raycast_break + collision_normal
	
	var tile = tilemap.get_cellv(raycast_break)
	var item = $Player/Hotbar.items[$Player/Hotbar.selected_slot]
	
	var break_anim = $BreakAnimator/AnimatedSprite
	# ---------------------------------------------------------------------------------
	
	$BreakAnimator.position = tilemap.map_to_world(raycast_break)
	$CheckEntity.position = tilemap.map_to_world(raycast_build)
	
	if Input.is_action_just_pressed("build") and can_place(raycast_build, item):
		tilemap.set_cellv(raycast_build, item[0])
		item[1] -= 1
	elif Input.is_action_pressed("destroy") and tile != 3 and tile != -1 and break_anim.playing == false:
		break_anim.playing = true
		break_anim.frame = 1
		break_anim.speed_scale = 1/BlockProperties.properties[tile]["hardness"]*10
		
		selected_tile = tilemap.map_to_world(raycast_break)
		
	if break_anim.frame == 0 and break_anim.playing == true and tilemap.map_to_world(raycast_break) == selected_tile:
		if BlockProperties.properties[tile]["obtain_hand"] != -1:
			give_item(BlockProperties.properties[tile]["obtain_hand"])
			
		tilemap.set_cellv(raycast_break, -1)
		
		break_anim.playing = false
		break_anim.speed_scale = 0

	if tilemap.map_to_world(raycast_break) != selected_tile:
		break_anim.playing = false
		break_anim.frame = 0
		break_anim.speed_scale = 0
		
		selected_tile = Vector2(0, 0)
			
func can_place(pos, item):
	var can_place = false
	
	# ---------------------------------------------------------------------------------

	if item[1] >= 1 and tilemap.get_cellv(pos) == -1 and not entity_in:
		can_place = true

	return can_place
	
func give_item(tile):
	var items = $Player/Hotbar.items
	
	# ---------------------------------------------------------------------------------
	
	for i in range(len(items)):
		var item = items[i]
		
		if item[0] == tile and item[1] < 64:
			item[1] += 1
			break
		elif item[0] == -1:
			item[0] = tile
			item[1] += 1
			break

func _on_CheckEntity_body_entered(body):
	if body.get("name") != "Terrain":
		entity_in = true

func _on_CheckEntity_body_exited(body):
	if body.get("name") != "Terrain":
		entity_in = false
