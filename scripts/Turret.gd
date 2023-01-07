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
func _ready():
	look_towards_nearest_enemy()
	
func _process(delta):
	look_towards_nearest_enemy()
