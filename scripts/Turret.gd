extends Sprite

export(int) var cost = 20
export(float) var attack_range = 192

var last_enemy_pos = null

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
		
	return enemy_pos

func attack():
	var bullet = load("res://TurretBullet.tscn")
	var bullet_inst = bullet.instance()
	bullet_inst.position = position
	bullet_inst.rotation = rotation
	
	if last_enemy_pos != null:
		if get_tree().get_nodes_in_group("enemy").size() > 0 and position.distance_to(last_enemy_pos) <= attack_range:
			get_tree().get_current_scene().add_child(bullet_inst)
	
	yield(get_tree().create_timer(1), "timeout")
	attack()
	
func _ready():
	last_enemy_pos = look_towards_nearest_enemy()
	attack()
	
func _process(delta):
	last_enemy_pos = look_towards_nearest_enemy()
