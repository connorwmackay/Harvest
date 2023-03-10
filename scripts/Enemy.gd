extends RigidBody2D

var health: int = 5
export(float) var move_speed = 32
var target_pos = null

onready var research_panel = get_tree().get_current_scene().find_node("ResearchPanel")
onready var audio_stream_player = find_node("AudioStreamPlayer")

func find_nearest_plant_pos(pos_exclusions = []):
	var plant_pos = null
	
	for plant in get_tree().get_nodes_in_group("plant"):
		var ignore_plant = false
		
		for pos in pos_exclusions:
			if plant.position == pos:
				ignore_plant = true
		
		if not ignore_plant:
			if plant_pos == null:
				plant_pos = plant.position
			elif plant.position.distance_to(position) < plant_pos.distance_to(position):
				plant_pos = plant.position
	
	return plant_pos

func find_nearest_turret_pos():
	var turret_pos = null
	
	for turret in get_tree().get_nodes_in_group("turret"):
		if turret_pos == null:
			turret_pos = turret.position
		elif turret.position.distance_to(position) < turret_pos.distance_to(position):
			turret_pos = turret.position
	
	return turret_pos

func attack_group_if_possible(group_name: String):
	for group in get_tree().get_nodes_in_group(group_name):
		if group.position == position:
			group.queue_free()
			new_target_pos([target_pos])

func new_target_pos(pos_exclusions = []):
	target_pos = null
	target_pos = find_nearest_plant_pos(pos_exclusions)
	
	if target_pos == null:
		target_pos = find_nearest_turret_pos()

func recieve_damage(damage):
	health -= damage
	audio_stream_player.play()
	
	if health <= 0:
		queue_free()
		return true
	else:
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	new_target_pos()

func _process(delta):
	gravity_scale = 0
	
	new_target_pos()
	
	if target_pos != null:
		position = position.move_toward(target_pos, move_speed * delta)
		attack_group_if_possible("plant")
		attack_group_if_possible("turret")
		
	for body in get_colliding_bodies():
		if body.is_in_group("bullet"):
			body.queue_free()
			recieve_damage(research_panel.turret_damage)
		
