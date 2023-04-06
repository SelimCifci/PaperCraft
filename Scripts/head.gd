extends Sprite

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	
	if get_global_mouse_position().x >= global_position.x:
		get_parent().scale.x = 1
	elif get_global_mouse_position().x < global_position.x:
		get_parent().scale.x = -1
