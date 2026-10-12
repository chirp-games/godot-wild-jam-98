extends Node2D

var currently_building_wire: Wire
const wire_scene = preload("res://game/MechBuilder/Wire.tscn")

func find_wire_receptacles():
	return get_tree().get_nodes_in_group("wire_receptacle")

func find_towers():
	return get_tree().get_nodes_in_group("tower")

func find_mini_frogs():
	return get_tree().get_nodes_in_group("mini_frog")


func _ready() -> void:
	for receptacle: WireReceptacle in find_wire_receptacles():
		receptacle.wire_started.connect(func(): _wire_started(receptacle))
	for tower: Tower in find_towers():
		tower.enemy_detected.connect(func(enemy: Enemy): _enemy_detected(tower, enemy))
	for frog: MiniFrog in find_mini_frogs():
		frog.create_attack.connect(func(bullet_spawner: BulletSpawner): await _create_attack(frog, bullet_spawner))

func _wire_started(receptacle: WireReceptacle):
	if currently_building_wire:
		return
	var w: Wire = wire_scene.instantiate()
	%Wires.add_child(w)
	w.a = receptacle
	currently_building_wire = w

func try_placing_wire():
	if not currently_building_wire:
		return
	for receptacle: WireReceptacle in find_wire_receptacles():
		if currently_building_wire.a == receptacle:
			continue
		if receptacle.get_global_rect().has_point(get_global_mouse_position()) and receptacle.type != currently_building_wire.a.type:
			currently_building_wire.b = receptacle
			currently_building_wire = null
			return
	currently_building_wire.queue_free()
	currently_building_wire = null

func _enemy_detected(tower: Tower, enemy: Enemy):
	var frogs = tower.get_connected_frogs()
	for frog: MiniFrog in frogs:
		frog.try_attack(enemy)

func _create_attack(frog: MiniFrog, bullet_spawner: BulletSpawner):
	add_child(bullet_spawner)
	bullet_spawner.global_position = frog.global_position + Vector2(20, -10)
	await bullet_spawner.fire_bullets()


func _input(event: InputEvent) -> void:
	if event.is_action_released("right_click", true):
		try_placing_wire()
