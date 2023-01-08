extends Node2D

onready var back_btn = find_node("BackButton")

func _ready():
	back_btn.connect("pressed", self, "_back_button_pressed")

func _back_button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
