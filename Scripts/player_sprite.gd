extends Node2D

@onready var head = $Head
@onready var anim = $AnimationPlayer

func _process(_delta):
	#Head rotation
	head.look_at(get_global_mouse_position())
	
	#Sprite flipping
	if get_global_mouse_position().x >= head.global_position.x:
		transform.x = Vector2(0.9,0)
	elif get_global_mouse_position().x < head.global_position.x:
		transform.x = Vector2(-0.9,0)
