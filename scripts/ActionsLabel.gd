extends Label

onready var selection_mode = get_tree().get_current_scene().get_node("SelectedTile")

func _process(delta):
	var num_actions_left = (selection_mode.num_actions_per_advance - selection_mode.num_actions)
	text = num_actions_left as String + " Actions Left"
