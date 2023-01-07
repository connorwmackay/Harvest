extends Sprite

export(int) var cost = 20

func look_towards_nearest_enemy():
	var enemy_pos = null
	# Find the closest enemy to self
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy_pos == null:
			enemy_pos = enemy.position
		else:
			if enemy.position.distance_to(position) < enemy_pos.distance_to(position):
				enemy_pos = enemy.position
	
	if enemy_pos != null:
		look_at(enemy_pos)
	else:
		set_global_rotation(0)

func attack():
	var bullet = load("res://TurretBullet.tscn")
	var bullet_inst = bullet.instance()
	bullet_inst.position = position
	bullet_inst.rotation = rotation
	
	if get_tree().get_nodes_in_group("enemy").size() > 0:
		get_tree().get_current_scene().add_child(bullet_inst)
	
	yield(get_tree().create_timer(1), "timeout")
	attack()
	
func _ready():
	look_towards_nearest_enemy()
	attack()
	
func _process(delta):
	look_towards_nearest_enemy()
		
