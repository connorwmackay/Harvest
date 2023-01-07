extends Node2D

onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")

var days_existed = 0
export(int) var days_until_mid = 1
export(int) var days_until_end = 2

var was_watered = false

func recieve_new_day():
	days_existed += 1
	was_watered = false
	
	if days_existed >= days_until_mid:
		animated_sprite.set_animation("Mid")
	
	if days_existed >= days_until_end:
		animated_sprite.set_animation("Final")

func recieve_watered():
	was_watered = true

func _ready():
	was_watered = false
	animated_sprite.set_animation("Early")
	days_existed = 0
