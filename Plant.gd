extends Node2D

onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var money = get_tree().get_current_scene().find_node("Money")

var days_existed = 0
export(int) var days_until_mid = 1
export(int) var days_until_end = 2
export(int) var max_days_no_water = 0
export(int) var value = 10
export(int) var cost = 5

var was_watered = false
var num_days_not_watered = 0

func recieve_new_day():
	days_existed += 1
	
	if not was_watered:
		num_days_not_watered += 1
	
	if num_days_not_watered > max_days_no_water:
		queue_free()
	
	was_watered = false
	
	if days_existed >= days_until_mid:
		animated_sprite.set_animation("Mid")
	
	if days_existed >= days_until_end:
		animated_sprite.set_animation("Final")

func recieve_watered():
	was_watered = true
	num_days_not_watered = 0

func can_sell_plant():
	if days_existed >= days_until_end:
		return true
	
	return false

func sell_plant():
	money.gain_money(value)
	queue_free()

func _ready():
	num_days_not_watered = 0
	was_watered = false
	animated_sprite.set_animation("Early")
	days_existed = 0
