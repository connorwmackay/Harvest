extends Node2D

onready var back_btn = find_node("BackButton")
onready var volume_hslider = find_node("VolumeHSlider")

func _ready():
	back_btn.connect("pressed", self, "_back_button_pressed")

func _back_button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

func _on_VolumeHSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), log(value) * 20)
