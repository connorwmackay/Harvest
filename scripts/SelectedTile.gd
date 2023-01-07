extends Sprite

enum SelectionMode {
	Till,
	Water,
	Plant,
	Sell
}

onready var tilemap = get_tree().get_current_scene().get_node("TileMap")
onready var datetime: DateTime = get_tree().get_current_scene().find_node("DateTime")

var selected_mode = SelectionMode.Till

var num_actions_per_advance = 10
var num_actions = 0

# Used to find the closest tile position
func find_closest_val(val, multiple):
	var quotient = val / multiple
	
	var option1 = multiple * quotient
	var option2 = multiple * (quotient + 1)
	
	if (abs(val - option1) < abs(val - option2)):
		return option1
		
	return option2

func _ready():
	selected_mode = SelectionMode.Till

func _process(delta):
	if Input.is_action_just_pressed("plant"):
		selected_mode = SelectionMode.Plant
	elif Input.is_action_just_pressed("till"):
		selected_mode = SelectionMode.Till
	elif Input.is_action_just_pressed("water"):
		selected_mode = SelectionMode.Water
	elif Input.is_action_just_pressed("sell"):
		selected_mode = SelectionMode.Sell
	
	# Set the position to be aligned to the tilemap grid
	var mouse_map_coord = tilemap.world_to_map(get_global_mouse_position())
	var map_cell = tilemap.get_cell(mouse_map_coord.x, mouse_map_coord.y)
	if map_cell != tilemap.INVALID_CELL:
		position = tilemap.map_to_world(mouse_map_coord)
	
	# Turn a tile to dirt
	if Input.is_action_pressed("select"):
		if selected_mode == SelectionMode.Till and map_cell == 1:
			tilemap.set_cell(mouse_map_coord.x, mouse_map_coord.y, 0)
			num_actions += 1
		elif selected_mode == SelectionMode.Plant and (map_cell == 0 or map_cell == 2):
			var can_plant = true
			
			# Check for an existing plant
			for plant_exst in get_tree().get_nodes_in_group("plant"):
				if plant_exst.position == tilemap.map_to_world(mouse_map_coord):
					can_plant = false
			
			# Only plant the plant if there wasn't a plant on the tile
			if can_plant:
				var plant = load("res://CarrotPlant.tscn")
				var plant_inst = plant.instance()
				plant_inst.position = tilemap.map_to_world(mouse_map_coord)
				get_tree().get_current_scene().add_child(plant_inst)
				num_actions += 1
		elif selected_mode == SelectionMode.Sell:
			for plant in get_tree().get_nodes_in_group("plant"):
				if plant.position == position and plant.can_sell_plant():
					plant.sell_plant()
					num_actions += 1
		elif selected_mode == SelectionMode.Water and map_cell == 0:
			tilemap.set_cell(mouse_map_coord.x, mouse_map_coord.y, 2)
			for plant in get_tree().get_nodes_in_group("plant"):
				if plant.position == position:
					plant.recieve_watered()
			
			num_actions += 1
	
	if num_actions >= num_actions_per_advance:
		num_actions = 0
		datetime.advance_day()
