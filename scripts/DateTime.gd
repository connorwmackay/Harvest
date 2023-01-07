extends HBoxContainer
class_name DateTime

onready var time: Label = get_node("Time")
onready var day_num: Label = get_node("DayNum")

onready var tilemap = get_tree().get_current_scene().get_node("TileMap")
onready var selection_mode = get_tree().get_current_scene().get_node("SelectedTile")

var day_ind = 1
var time_ind = 0

var num_enemies_to_spawn = 1
var start_enemy_health = 5

func spawn_enemies(num: int):
	var spawn_points = get_tree().get_nodes_in_group("spawn_point")
	var enemy = load("res://Enemy.tscn")

	if num > spawn_points.size():
		num = spawn_points.size()
	
	for n in num:
		var enemy_inst = enemy.instance()
		enemy_inst.health = start_enemy_health
		enemy_inst.position = spawn_points[n].position
		get_tree().get_current_scene().add_child(enemy_inst)

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
		spawn_enemies(num_enemies_to_spawn)

func set_day():
	day_num.text = "Day " + day_ind as String

func advance_day():
	var are_there_enemies = false
	if get_tree().get_nodes_in_group("enemy").size() > 0:
		are_there_enemies = true
	
	if time.text == "Night" and are_there_enemies:
		return
	
	time_ind += 1
	selection_mode.num_actions = 0
	
	if time_ind > 3:
		time_ind = 0
		day_ind += 1
		set_day()
		
		if day_ind % 2 == 0:
			num_enemies_to_spawn += 1
		
		if day_ind % 4 == 0:
			start_enemy_health += 1
		
		for plant in get_tree().get_nodes_in_group("plant"):
			plant.recieve_new_day()
			
		for tilemap_cell_pos in tilemap.get_used_cells():
			var cell = tilemap.get_cell(tilemap_cell_pos.x, tilemap_cell_pos.y)
			if cell == 2: # Watered
				tilemap.set_cell(tilemap_cell_pos.x, tilemap_cell_pos.y, 0)	
	set_time()

func _process(delta):
	if Input.is_action_just_pressed("advance_day"):
		advance_day()
