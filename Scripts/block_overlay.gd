extends TileMap

func _process(_delta):
	self.clear()
	
	self.set_cellv(get_parent().raycast_break, 0)
