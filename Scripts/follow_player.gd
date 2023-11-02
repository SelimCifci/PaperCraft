extends Node2D

func _process(_delta):
	transform.origin = get_parent().get_node("Player").transform.origin
