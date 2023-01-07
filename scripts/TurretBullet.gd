extends RigidBody2D

export(float) var move_speed = 10000
export(int) var damage = 1

onready var sprite = get_node("Sprite")

func _process(delta):
	gravity_scale = 0
	apply_central_impulse(Vector2(cos(rotation), sin(rotation)) * move_speed * delta)
