extends Node2D

var currently_building_wire: Wire
const wire_scene = preload("res://game/MechBuilder/Wire.tscn")
const MAX_CONNECTION_DIST = 300

var frogs_to_closest_tower: Dictionary[MiniFrog, Tower] = {}

func find_wire_receptacles():
	return get_tree().get_nodes_in_group("wire_receptacle")

func find_wires():
	return get_tree().get_nodes_in_group("wire")

func find_towers():
	return get_tree().get_nodes_in_group("tower")

func find_mini_frogs():
	return get_tree().get_nodes_in_group("mini_frog")


func _ready() -> void:
	for frog: MiniFrog in find_mini_frogs():
		frog.create_attack.connect(func(bullet_spawner: BulletSpawner): await _create_attack(frog, bullet_spawner))

func _process(delta: float) -> void:
	for frog: MiniFrog in find_mini_frogs():
		var closest_tower = frogs_to_closest_tower.get(frog)
		var new_closest_tower := get_closest_tower(frog)
		
		if closest_tower != new_closest_tower:
			frogs_to_closest_tower[frog] = new_closest_tower

		if frog.global_position.distance_to(new_closest_tower.global_position) > MAX_CONNECTION_DIST:
			closest_tower_lost(frog)
			frogs_to_closest_tower[frog] = null

		if frogs_to_closest_tower[frog]:
			closest_tower_found(frog, frogs_to_closest_tower[frog])

func _enemy_detected(tower: Tower, enemy: Enemy):
	var frogs = tower.get_connected_frogs()
	for frog: MiniFrog in frogs:
		frog.try_attack(enemy)

func _create_attack(frog: MiniFrog, bullet_spawner: BulletSpawner):
	add_child(bullet_spawner)
	bullet_spawner.global_position = frog.global_position + Vector2(20, -10)
	await bullet_spawner.fire_bullets()

func get_closest_tower(frog: MiniFrog) -> Tower:
	var towers = find_towers()
	towers.sort_custom(func(x: Tower, y: Tower): return x.global_position.distance_squared_to(frog.global_position) < y.global_position.distance_squared_to(frog.global_position))
	return towers.get(0)

func create_wire(frog: MiniFrog, tower: Tower):
	var w: Wire = wire_scene.instantiate()
	w.a = frog.get_receptacle()
	w.b = tower.wire_receptacle
	%Wires.add_child(w)

func closest_tower_lost(frog: MiniFrog):
	# When the frog is picked up, remove any current connections
	for wire in find_wires():
		if wire.a == frog.get_receptacle():
			wire.queue_free()

func closest_tower_found(frog: MiniFrog, tower: Tower):
	create_wire(frog, tower)
