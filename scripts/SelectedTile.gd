extends Sprite

onready var tilemap = get_tree().get_current_scene().get_node("TileMap")

# Used to find the closest tile position
func find_closest_val(val, multiple):
	var quotient = val / multiple
	
	var option1 = multiple * quotient
	var option2 = multiple * (quotient + 1)
	
	if (abs(val - option1) < abs(val - option2)):
		return option1
		
	return option2
	
func _process(delta):
	var mouse_map_coord = tilemap.world_to_map(get_global_mouse_position())
	var map_cell = tilemap.get_cell(mouse_map_coord.x, mouse_map_coord.y)
	if map_cell != tilemap.INVALID_CELL:
		position = tilemap.map_to_world(mouse_map_coord)
