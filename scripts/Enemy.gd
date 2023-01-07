extends RigidBody2D

export(float) var move_speed = 32
var target_pos = null

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
		elif turret.position.distance_to(position) < turret_pos.distance_to(turret):
			turret_pos = turret.position
	
	return turret_pos

func find_random_pos_on_tilemap():
	return null

func attack_plant_if_possible():
	for plant in get_tree().get_nodes_in_group("plant"):
		if plant.position == position:
			plant.queue_free()
			new_target_pos([target_pos])

func new_target_pos(pos_exclusions = []):
	target_pos = null
	target_pos = find_nearest_plant_pos(pos_exclusions)
	
	if target_pos == null:
		target_pos = find_nearest_turret_pos()
	
	if target_pos == null:
		target_pos = find_random_pos_on_tilemap()

# Called when the node enters the scene tree for the first time.
func _ready():
	new_target_pos()

func _process(delta):
	gravity_scale = 0
	if target_pos != null:
		position = position.move_toward(target_pos, move_speed * delta)
		attack_plant_if_possible()
		
	for body in get_colliding_bodies():
		if body.is_in_group("bullet"):
			body.queue_free()
			queue_free()
		
