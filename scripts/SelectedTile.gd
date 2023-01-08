extends Sprite

enum SelectionMode {
	Till,
	Water,
	Plant,
	Sell,
	Turret
}

onready var tilemap = get_tree().get_current_scene().get_node("TileMap")
onready var datetime: DateTime = get_tree().get_current_scene().find_node("DateTime")
onready var money = get_tree().get_current_scene().find_node("Money")
onready var research_panel = get_tree().get_current_scene().find_node("ResearchPanel")

onready var water_audio_player = find_node("WaterAudioPlayer")
onready var sell_audio_player = find_node("SellAudioPlayer")
onready var till_audio_player = find_node("TillAudioPlayer")
onready var plant_audio_player = find_node("PlantAudioPlayer")

var selected_mode = SelectionMode.Till

var num_actions_per_advance = 10
var num_actions = 0

var using_ui = false

func _ready():
	selected_mode = SelectionMode.Till
	using_ui = false

func switch_selection_mode():
	if Input.is_action_just_pressed("plant"):
		selected_mode = SelectionMode.Plant
	elif Input.is_action_just_pressed("till"):
		selected_mode = SelectionMode.Till
	elif Input.is_action_just_pressed("water"):
		selected_mode = SelectionMode.Water
	elif Input.is_action_just_pressed("sell"):
		selected_mode = SelectionMode.Sell
	elif Input.is_action_just_pressed("turret"):
		selected_mode = SelectionMode.Turret

func use_selection_mode():
	# Turn a tile to dirt
	if Input.is_action_pressed("select"):
		var mouse_map_coord = tilemap.world_to_map(get_global_mouse_position())
		var map_cell = tilemap.get_cell(mouse_map_coord.x, mouse_map_coord.y)
		
		if selected_mode == SelectionMode.Till and map_cell == 1:
			till_audio_player.play()
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
				plant_audio_player.play()
				
				if map_cell == 2:
					plant_inst.recieve_watered()
				
				if money.can_lose_money(plant_inst.cost):
					money.lose_money(plant_inst.cost)
					plant_inst.position = tilemap.map_to_world(mouse_map_coord)
					get_tree().get_current_scene().add_child(plant_inst)
					num_actions += 1
		elif selected_mode == SelectionMode.Sell:
			for plant in get_tree().get_nodes_in_group("plant"):
				if plant.position == position and plant.can_sell_plant():
					plant.sell_plant()
					sell_audio_player.play()
					#num_actions += 1
		elif selected_mode == SelectionMode.Water and map_cell == 0:
			tilemap.set_cell(mouse_map_coord.x, mouse_map_coord.y, 2)
			for plant in get_tree().get_nodes_in_group("plant"):
				if plant.position == position:
					plant.recieve_watered()
			
			num_actions += 1
			water_audio_player.play()
		elif selected_mode == SelectionMode.Turret and map_cell == 1:
			var should_spawn_turret = true
			for existing_turret in get_tree().get_nodes_in_group("turret"):
				if existing_turret.position == tilemap.map_to_world(mouse_map_coord):
					should_spawn_turret = false
			
			var turret = load("res://Turret.tscn")
			var turret_inst = turret.instance()
			
			if money.can_lose_money(research_panel.turret_cost) and should_spawn_turret:
				money.lose_money(research_panel.turret_cost)
				research_panel.turret_cost *= research_panel.turret_cost_increase
				turret_inst.position = tilemap.map_to_world(mouse_map_coord)
				get_tree().get_current_scene().add_child(turret_inst)
	
	if num_actions >= num_actions_per_advance:
		datetime.advance_day()

func _process(delta):
	if not using_ui:
		# Set the position to be aligned to the tilemap grid
		var mouse_map_coord = tilemap.world_to_map(get_global_mouse_position())
		var map_cell = tilemap.get_cell(mouse_map_coord.x, mouse_map_coord.y)
		if map_cell != tilemap.INVALID_CELL:
			position = tilemap.map_to_world(mouse_map_coord)
	
	if not using_ui and num_actions < num_actions_per_advance:
		switch_selection_mode()
		use_selection_mode()
