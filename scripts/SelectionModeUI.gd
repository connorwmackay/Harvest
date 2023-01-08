extends PanelContainer

onready var tillButton = find_node("TillButton")
onready var waterButton = find_node("WaterButton")
onready var farmButton = find_node("FarmButton")
onready var sellButton = find_node("SellButton")
onready var turretButton = find_node("TurretButton")
onready var advanceButton = find_node("AdvanceButton")
onready var researchButton = find_node("ResearchButton")

onready var selection_mode = get_tree().get_current_scene().get_node("SelectedTile")
onready var datetime = get_tree().get_current_scene().find_node("DateTime")
onready var research_panel = get_tree().get_current_scene().find_node("ResearchPanel")

func set_turret_price_text(cost):
	turretButton.text = "Turret (£" + cost as String + ")"

func _ready():
	tillButton.connect("pressed", self, "_till_button_pressed")
	waterButton.connect("pressed", self, "_water_button_pressed")
	farmButton.connect("pressed", self, "_farm_button_pressed")
	sellButton.connect("pressed", self, "_sell_button_pressed")
	turretButton.connect("pressed", self, "_turret_button_pressed")
	advanceButton.connect("pressed", self, "_advance_button_pressed")
	researchButton.connect("pressed", self, "_research_button_pressed")

func focus_till():
	tillButton.pressed = true
	waterButton.pressed = false
	farmButton.pressed = false
	sellButton.pressed = false
	turretButton.pressed = false

func focus_water():
	tillButton.pressed = false
	waterButton.pressed = true
	farmButton.pressed = false
	sellButton.pressed = false
	turretButton.pressed = false

func focus_farm():
	tillButton.pressed = false
	waterButton.pressed = false
	farmButton.pressed = true
	sellButton.pressed = false
	turretButton.pressed = false

func focus_sell():
	tillButton.pressed = false
	waterButton.pressed = false
	farmButton.pressed = false
	sellButton.pressed = true
	turretButton.pressed = false

func focus_turret():
	tillButton.pressed = false
	waterButton.pressed = false
	farmButton.pressed = false
	sellButton.pressed = false
	turretButton.pressed = true

func _till_button_pressed():
	focus_till()
	selection_mode.selected_mode = selection_mode.SelectionMode.Till

func _water_button_pressed():
	focus_water()
	selection_mode.selected_mode = selection_mode.SelectionMode.Water

func _farm_button_pressed():
	focus_farm()
	selection_mode.selected_mode = selection_mode.SelectionMode.Plant

func _sell_button_pressed():
	focus_sell()
	selection_mode.selected_mode = selection_mode.SelectionMode.Sell

func _turret_button_pressed():
	focus_turret()
	selection_mode.selected_mode = selection_mode.SelectionMode.Turret

func _advance_button_pressed():
	datetime.advance_day()

func _research_button_pressed():
	research_panel.visible = !research_panel.visible

func _on_SelectionModeUI_mouse_entered():
	selection_mode.using_ui = true

func _on_SelectionModeUI_mouse_exited():
	if not get_global_rect().has_point(self.get_global_mouse_position()):
		selection_mode.using_ui = false
		
func _process(delta):
	if Input.is_action_just_pressed("plant"):
		focus_farm()
	elif Input.is_action_just_pressed("till"):
		focus_till()
	elif Input.is_action_just_pressed("water"):
		focus_water()
	elif Input.is_action_just_pressed("sell"):
		focus_sell()
	elif Input.is_action_just_pressed("turret"):
		focus_turret()
	
	var num_enemies = get_tree().get_nodes_in_group("enemy").size()
	if datetime.time.text == "Night" && num_enemies > 0:
		advanceButton.disabled = true
	else:
		advanceButton.disabled = false
	
	set_turret_price_text(research_panel.turret_cost)
