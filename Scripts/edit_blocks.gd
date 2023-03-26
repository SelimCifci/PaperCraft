extends Node2D

onready var tilemap = $Terrain
export var raycast_collision_break = Vector2.ZERO
export var raycast_collision_build = Vector2.ZERO

var entity_in = false

func _physics_process(_delta):
	var collision_point = $Player/RayCast2D.get_collision_point()
	var collision_normal = $Player/RayCast2D.get_collision_normal()
	
	raycast_collision_break = tilemap.world_to_map(collision_point - collision_normal * 8)
	raycast_collision_build = raycast_collision_break + collision_normal
	
	$CheckEntity.position = tilemap.map_to_world(raycast_collision_build)
	$BreakAnimator.position = tilemap.map_to_world(raycast_collision_break)
	
	var tile = tilemap.get_cellv(raycast_collision_break)
	var selected_item = $Player/Hotbar.items[$Player/Hotbar.selected_slot]
	
	if Input.is_action_just_pressed("build") and can_place(raycast_collision_build):
		tilemap.set_cellv(raycast_collision_build, selected_item[0])
		selected_item[1] -= 1
	elif Input.is_action_just_pressed("destroy") and tile != 3:
		var hardness = BlockProperties.properties[tile]["hardness"]
		var current_pos = raycast_collision_break
		
		var animator = $BreakAnimator/AnimatedSprite

		animator.speed_scale = 10 / hardness
		animator.playing = true
		
		yield(get_tree().create_timer(hardness), "timeout")
		
		animator.playing = false
		animator.frame = 0
		
		if raycast_collision_break == current_pos:
			give_item(tile)
			tilemap.set_cellv(current_pos, -1)
			
func can_place(pos):
	var can_place = false

	if $Player/Hotbar.items[$Player/Hotbar.selected_slot][1] >= 1 and tilemap.get_cellv(pos) == -1:
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

func _on_CheckEntity_body_entered(body):
	if body.get("name") != "Terrain":
		entity_in = true

func _on_CheckEntity_body_exited(body):
	if body.get("name") != "Terrain":
		entity_in = false
