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
