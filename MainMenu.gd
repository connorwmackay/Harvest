extends Node2D

onready var play_btn = find_node("PlayButton")
onready var options_btn = find_node("OptionsButton")
onready var quit_btn = find_node("QuitButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	play_btn.connect("pressed", self, "_play_button_pressed")
	options_btn.connect("pressed", self, "_options_button_pressed")
	quit_btn.connect("pressed", self, "_quit_button_pressed")
	
func _play_button_pressed():
	get_tree().change_scene("res://Game.tscn")

func _options_button_pressed():
	get_tree().change_scene("res://Options.tscn")

func _quit_button_pressed():
	get_tree().quit()
