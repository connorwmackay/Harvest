extends PanelContainer

onready var num_actions_btn = find_node("NumActionsButton")
onready var turret_damage_btn = find_node("TurretDamageButton")
onready var turret_range_btn = find_node("TurretRangeButton")

onready var money = get_tree().get_current_scene().find_node("Money")

onready var selection_mode = get_tree().get_current_scene().get_node("SelectedTile")

var num_actions_cost = 10
var turret_damage_cost = 20
var turret_range_cost = 20

var turret_damage = 1
var turret_range = 256

func _ready():
	num_actions_btn.connect("pressed", self, "_num_actions_button_pressed")
	turret_damage_btn.connect("pressed", self, "_turret_damage_button_pressed")
	turret_range_btn.connect("pressed", self, "_turret_range_button_pressed")
	turret_range = 256
	turret_damage = 1

func _num_actions_button_pressed():
	money.lose_money(num_actions_cost)
	selection_mode.num_actions_per_advance += 1

func _turret_damage_button_pressed():
	money.lose_money(turret_damage_cost)
	turret_damage += 1

func _turret_range_button_pressed():
	money.lose_money(turret_range_cost)
	turret_range += 32

func _process(delta):
	if money.can_lose_money(num_actions_cost):
		num_actions_btn.disabled = false
	else:
		num_actions_btn.disabled = true
		
	if money.can_lose_money(turret_damage_cost):
		turret_damage_btn.disabled = false
	else:
		turret_damage_btn.disabled = true
		
	if money.can_lose_money(turret_range_cost):
		turret_range_btn.disabled = false
	else:
		turret_range_btn.disabled = true
	
	if Input.is_action_just_pressed("toggle_research_panel"):
		visible = !visible
		
		if not visible:
			selection_mode.using_ui = false


func _on_ResearchPanel_mouse_entered():
	selection_mode.using_ui = true

func _on_ResearchPanel_mouse_exited():
	if not get_global_rect().has_point(self.get_global_mouse_position()):
		selection_mode.using_ui = false
