extends Control

class_name Game

const wire_scene = preload("res://game/MechBuilder/Wire.tscn")
const MAX_CONNECTION_DIST = 300

@onready var player: Player = %Player
@onready var command_center: CommandCenter = %CommandCenter
@onready var command_center_camera: Camera2D = %CommandCenterCamera
@onready var player_camera: Camera2D = %PlayerCamera
@onready var start_wave_button: Button = %StartWaveButton
@onready var left_portal: Marker2D = %LeftPortal
@onready var right_portal: Marker2D = %RightPortal
@onready var health_label: Label = %Health
@onready var material_label: Label = %Material

var frogs_to_closest_commander: Dictionary[MiniFrog, MiniFrog] = {}
var currently_building_wire: Wire

var material_currency = 0

func find_wire_receptacles():
	return get_tree().get_nodes_in_group("wire_receptacle")

func find_wires():
	return get_tree().get_nodes_in_group("wire")

func find_commanders():
	return get_tree().get_nodes_in_group("mini_frog").filter(func(x): return x.rank == MiniFrog.Rank.Commander)

func find_recruits():
	return get_tree().get_nodes_in_group("mini_frog").filter(func(x): return x.rank == MiniFrog.Rank.Recruit)


func find_mini_frogs():
	return get_tree().get_nodes_in_group("mini_frog")

func _ready() -> void:
	for frog: MiniFrog in find_mini_frogs():
		frog.create_attack.connect(func(bullet_spawner: BulletSpawner): await _create_attack(frog, bullet_spawner))

	for commander: MiniFrog in find_commanders():
		commander.enemy_detected.connect(func(e: Enemy): _enemy_detected(commander, e))

	player_camera.make_current()

func _process(delta: float) -> void:
	for frog: MiniFrog in find_mini_frogs():
		var closest_commander = frogs_to_closest_commander.get(frog)
		var new_closest_commander := get_closest_commander(frog)
		
		var in_range = frog.global_position.distance_to(new_closest_commander.global_position) <= MAX_CONNECTION_DIST
		
		if closest_commander != new_closest_commander and in_range:
			frogs_to_closest_commander[frog] = new_closest_commander

		if frog.dragging and not in_range:
			closest_commander_lost(frog)
			frogs_to_closest_commander[frog] = null

		if in_range and frogs_to_closest_commander[frog] and frogs_to_closest_commander[frog] != closest_commander:
			closest_commander_found(frog, frogs_to_closest_commander[frog])

	health_label.text = "Health: " + str(command_center.health)
	material_label.text = "Material: " + str(material_currency)

func _enemy_detected(commander: MiniFrog, enemy: Enemy):
	var frogs = commander.get_connected_frogs()
	for frog: MiniFrog in frogs:
		frog.try_attack(enemy)

func _create_attack(frog: MiniFrog, bullet_spawner: BulletSpawner):
	add_child(bullet_spawner)
	bullet_spawner.global_position = frog.global_position + Vector2(20, -10)
	await bullet_spawner.fire_bullets()

func get_closest_commander(frog: MiniFrog) -> MiniFrog:
	var commanders = find_commanders()
	commanders.sort_custom(func(x: MiniFrog, y: MiniFrog): return x.global_position.distance_squared_to(frog.global_position) < y.global_position.distance_squared_to(frog.global_position))
	return commanders.get(0)

func create_wire(frog: MiniFrog, commander: MiniFrog):
	var w: Wire = wire_scene.instantiate()
	w.a = frog.get_receptacle()
	w.b = commander.get_receptacle()
	%Wires.add_child(w)

func closest_commander_lost(frog: MiniFrog):
	frog.connected = false
	# When the frog is picked up, remove any current connections
	for wire in find_wires():
		if wire.a == frog.get_receptacle() or wire.b == frog.get_receptacle():
			wire.queue_free()

func closest_commander_found(frog: MiniFrog, commander: MiniFrog):
	frog.connected = true
	create_wire(frog, commander)

func enter_command_mode():
	pass

func exit_command_mode():
	pass

func _on_wave_spawner_spawn_enemy(e: PackedScene) -> void:
	var new_enemy: Enemy = e.instantiate()
	new_enemy.global_position = [left_portal, right_portal].pick_random().global_position
	new_enemy.on_death.connect(func(): material_currency += 10)
	add_child(new_enemy)

func _on_wave_spawner_wave_ended() -> void:
	start_wave_button.show()

func _on_wave_spawner_wave_started() -> void:
	start_wave_button.hide()
