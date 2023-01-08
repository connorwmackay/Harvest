extends Label
class_name Money

export(int) var start_money = 50
var money = start_money

func gain_money(amount):
	money += amount
	
	text = "$" + money as String

func lose_money(amount):
	money -= amount
	
	if money < 0:
		money = 0
	
	text = "£" + money as String

func can_lose_money(amount):
	if money - amount < 0:
		return false
	
	return true

func _ready():
	money = start_money
	text = "£" + money as String
	
func _process(delta):
	var num_plants = get_tree().get_nodes_in_group("plant").size()
	
	if money <= 0 and num_plants <= 0:
		get_tree().change_scene("res://Lose.tscn")
