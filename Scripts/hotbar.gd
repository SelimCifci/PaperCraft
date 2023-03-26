extends Node

export var items = [[-1, 0], [-1, 0], [-1, 0], [-1, 0], [-1, 0], [-1, 0], [-1, 0], [-1, 0], [-1, 0]]

var hotbar_slots = 9
var selected_slot = 0

func _ready():
	light_up(selected_slot)
	
func _process(_delta):
	if Input.is_action_just_pressed("drop"):
		drop()
		
	show_items()
	check_items()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				light_down(selected_slot)
				
				if selected_slot == hotbar_slots-1:
					selected_slot = 0
				else:
					selected_slot += 1
					
				light_up(selected_slot)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				light_down(selected_slot)
				
				if selected_slot == 0:
					selected_slot = hotbar_slots-1
				else:
					selected_slot -= 1
					
				light_up(selected_slot)
			
func light_up(slot):
	get_node("Slot" + str(slot)).texture.region = Rect2(16, 112, 16, 16)
	
func light_down(previous):
	get_node("Slot" + str(previous)).texture.region = Rect2(0, 112, 16, 16)
	
func show_items():
	for i in range(hotbar_slots):
		if items[i][0] >= 0:
			get_node("Slot" + str(i)).get_child(0).texture.region = Rect2(items[i][0] * 16, 0, 16, 16)
			get_node("Slot" + str(i)).get_child(1).get_child(0).text = str(items[i][1])
		else:
			get_node("Slot" + str(i)).get_child(0).texture.region = Rect2(112, 112, 16, 16)
			get_node("Slot" + str(i)).get_child(1).get_child(0).text = ""
			
func check_items():
	for i in range(hotbar_slots):
		if items[i][1] == 0:
			items[i] = [-1, 0]
			
func drop():
	items[selected_slot][1] -= 1
	if items[selected_slot][1] == 0:
		items[selected_slot][0] = -1
