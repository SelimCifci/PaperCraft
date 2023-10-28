extends Node2D

func _process(_delta):
	transform.origin = get_parent().get_child(2).transform.origin
