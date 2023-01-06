extends Camera2D
class_name move_camera

export(int) var move_speed = 32

func get_offset():
	return offset

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		offset_v -= move_speed * delta
	elif Input.is_action_pressed("ui_down"):
		offset_v += move_speed * delta
	
	if Input.is_action_pressed("ui_right"):
		offset_h += move_speed * delta
	elif Input.is_action_pressed("ui_left"):
		offset_h -= move_speed * delta
