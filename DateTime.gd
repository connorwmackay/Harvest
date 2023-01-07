extends HBoxContainer
class_name DateTime

onready var time: Label = get_node("Time")
onready var day_num: Label = get_node("DayNum")

onready var tilemap = get_tree().get_current_scene().get_node("TileMap")

var day_ind = 1
var time_ind = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	day_ind = 1
	time_ind = 0
	set_time()
	set_day()

func set_time():
	if time_ind == 0:
		time.text = "Morning"
	elif time_ind == 1:
		time.text = "Afternoon"
	elif time_ind == 2:
		time.text = "Evening"
	elif time_ind == 3:
		time.text = "Night"

func set_day():
	day_num.text = "Day " + day_ind as String

func advance_day():
	time_ind += 1
	
	if time_ind > 3:
		time_ind = 0
		day_ind += 1
		set_day()
		
		for plant in get_tree().get_nodes_in_group("plant"):
			plant.recieve_new_day()
			
		for tilemap_cell_pos in tilemap.get_used_cells():
			var cell = tilemap.get_cell(tilemap_cell_pos.x, tilemap_cell_pos.y)
			if cell == 2: # Watered
				tilemap.set_cell(tilemap_cell_pos.x, tilemap_cell_pos.y, 0)	
	set_time()
