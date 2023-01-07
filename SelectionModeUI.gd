extends Panel

onready var tillButton = find_node("TillButton")
onready var waterButton = find_node("WaterButton")
onready var farmButton = find_node("FarmButton")
onready var sellButton = find_node("SellButton")
onready var turretButton = find_node("TurretButton")
onready var advanceButton = find_node("AdvanceButton")

onready var selection_mode = get_tree().get_current_scene().get_node("SelectedTile")
onready var datetime = get_tree().get_current_scene().find_node("DateTime")

func _ready():
	tillButton.connect("pressed", self, "_till_button_pressed")
	waterButton.connect("pressed", self, "_water_button_pressed")
	farmButton.connect("pressed", self, "_farm_button_pressed")
	sellButton.connect("pressed", self, "_sell_button_pressed")
	turretButton.connect("pressed", self, "_turret_button_pressed")
	advanceButton.connect("pressed", self, "_advance_button_pressed")

func _till_button_pressed():
	tillButton.pressed = true
	waterButton.pressed = false
	farmButton.pressed = false
	sellButton.pressed = false
	turretButton.pressed = false
	
	selection_mode.selected_mode = selection_mode.SelectionMode.Till

func _water_button_pressed():
	tillButton.pressed = false
	waterButton.pressed = true
	farmButton.pressed = false
	sellButton.pressed = false
	turretButton.pressed = false
	
	selection_mode.selected_mode = selection_mode.SelectionMode.Water

func _farm_button_pressed():
	tillButton.pressed = false
	waterButton.pressed = false
	farmButton.pressed = true
	sellButton.pressed = false
	turretButton.pressed = false
	
	selection_mode.selected_mode = selection_mode.SelectionMode.Plant

func _sell_button_pressed():
	tillButton.pressed = false
	waterButton.pressed = false
	farmButton.pressed = false
	sellButton.pressed = true
	turretButton.pressed = false
	
	selection_mode.selected_mode = selection_mode.SelectionMode.Sell

func _turret_button_pressed():
	tillButton.pressed = false
	waterButton.pressed = false
	farmButton.pressed = false
	sellButton.pressed = false
	turretButton.pressed = true
	
	selection_mode.selected_mode = selection_mode.SelectionMode.Turret

func _advance_button_pressed():
	datetime.advance_day()

func _on_SelectionModeUI_mouse_entered():
	selection_mode.using_ui = true

func _on_SelectionModeUI_mouse_exited():
	if not get_global_rect().has_point(self.get_global_mouse_position()):
		selection_mode.using_ui = false
		
func _process(delta):
	var num_enemies = get_tree().get_nodes_in_group("enemy").size()
	if datetime.time.text == "Night" && num_enemies > 0:
		advanceButton.disabled = true
	else:
		advanceButton.disabled = false
