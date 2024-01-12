extends Node2D

func _ready():
	transform.x = Vector2(get_viewport().size.x,0.0)
	transform.y = Vector2(0.0,get_viewport().size.y)

func _process(_delta):
	transform.origin = get_parent().get_node("Player").transform.origin
