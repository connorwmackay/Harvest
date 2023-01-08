extends PanelContainer

onready var selection_mode = get_tree().get_current_scene().get_node("SelectedTile")

func _process(delta):
	if Input.is_action_just_pressed("toggle_pause"):
		visible = !visible
		selection_mode.using_ui = false

func _on_ReturnButton_pressed():
	visible = !visible
	selection_mode.using_ui = false

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_PauseMenu_mouse_entered():
	selection_mode.using_ui = true

func _on_PauseMenu_mouse_exited():
	if not get_global_rect().has_point(self.get_global_mouse_position()):
		selection_mode.using_ui = false
