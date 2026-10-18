extends Control

class_name Game

signal enemy_corpse_amount_updated(new_amount: Dictionary[EnemyResource, int])

const wire_scene = preload("res://game/frog_mechs/Wire.tscn")
const player_mech_scene = preload("res://game/frog_mechs/frog_mech.tscn")
const enemy_scene = preload("res://game/enemy/Enemy.tscn")
const MAX_CONNECTION_DIST = 300

@onready var player: Player = %Player
@onready var command_center: CommandCenter = %CommandCenter
@onready var scrapyard: Control = %Scrapyard
@onready var command_center_camera: Camera2D = %CommandCenterCamera
@onready var player_camera: Camera2D = %PlayerCamera
@onready var start_wave_button: Button = %StartWaveButton
@onready var left_portal: Marker2D = %LeftPortal
@onready var right_portal: Marker2D = %RightPortal
@onready var health_label: Label = %Health
@onready var material_label: Label = %Material

var frogs_to_closest_commander: Dictionary = {}
var enemy_corpses_collected: Dictionary[EnemyResource, int] = {}
var currently_building_wire: Wire
var material_currency = 0

func find_wire_receptacles():
	return get_tree().get_nodes_in_group("wire_receptacle")

func find_wires():
	return get_tree().get_nodes_in_group("wire")

func find_commanders():
	# The player is a commander now...
	return get_tree().get_nodes_in_group("frog_mech").filter(func(x): return x.resource.mech_class == MechResource.MechClass.Commander) + [player]

func find_recruits():
	return get_tree().get_nodes_in_group("frog_mech").filter(func(x): return x.resource.mech_class == MechResource.MechClass.Recruit)

func find_frog_mechs():
	return get_tree().get_nodes_in_group("frog_mech")

func _ready() -> void:
	Vfx.reparent.call_deferred(self)
	
	for frog: FrogMech in find_frog_mechs():
		frog.create_attack.connect(func(bullet_spawner: BulletSpawner): await _create_attack(frog, bullet_spawner))

	for commander in find_commanders():
		commander.enemy_detected.connect(func(e: Enemy): _enemy_detected(commander, e))
		pass

	player_camera.make_current()

	for e in Resources.enemies:
		enemy_corpses_collected.get_or_add(e, 0)

func _process(_delta: float) -> void:
	#for frog: FrogMech in find_frog_mechs():
		#var closest_commander = frogs_to_closest_commander.get(frog)
		#var new_closest_commander = get_closest_commander(frog)
		#
		#var in_range = frog.global_position.distance_to(new_closest_commander.global_position) <= MAX_CONNECTION_DIST
#
		#if closest_commander != new_closest_commander and in_range:
			#frogs_to_closest_commander[frog] = new_closest_commander
#
		#if frog.dragging and not in_range:
			#closest_commander_lost(frog)
			#frogs_to_closest_commander[frog] = null
#
		#if frogs_to_closest_commander.get(frog) and frogs_to_closest_commander[frog] != closest_commander and (frog.dragging or frog.get_connected_commander() == null):
			#closest_commander_lost(frog)
			#closest_commander_found(frog, new_closest_commander)

	health_label.text = "Health: " + str(command_center.get_health())
	material_label.text = "Material: " + str(material_currency)

func _enemy_detected(commander: FrogMech, enemy: Enemy):
	var frogs = commander.get_connected_frogs()
	for frog: FrogMech in frogs:
		frog.try_attack(enemy)

func _create_attack(frog: FrogMech, bullet_spawner: BulletSpawner):
	add_child(bullet_spawner)
	bullet_spawner.global_position = frog.global_position + Vector2(20, -10)
	await bullet_spawner.fire_bullets()

func get_closest_commander(frog: FrogMech):
	var commanders = find_commanders()
	commanders.sort_custom(func(x, y): return x.global_position.distance_squared_to(frog.global_position) < y.global_position.distance_squared_to(frog.global_position))
	return commanders.get(0)

func create_wire(frog, commander):
	var w: Wire = wire_scene.instantiate()
	w.a = frog.get_receptacle()
	w.b = commander.get_receptacle()
	%Wires.add_child(w)

func closest_commander_lost(frog: FrogMech):
	# When the frog is picked up, remove any current connections
	for wire in find_wires():
		if wire.a == frog.get_receptacle() or wire.b == frog.get_receptacle():
			wire.queue_free()

func closest_commander_found(frog, commander):
	create_wire(frog, commander)

func enter_scrapyard():
	scrapyard.show()

func exit_scrapyard():
	scrapyard.hide()

func _on_wave_spawner_spawn_enemy(new_enemy: Enemy, around_enemy: Enemy) -> void:
	# Enemies are scenes with a resource assigned to them
	if not around_enemy:
		new_enemy.global_position = [left_portal, right_portal].pick_random().global_position
	else:
		new_enemy.global_position = Vector2(around_enemy.global_position.x + randi_range(-200, 200), -700)
	
	new_enemy.on_death.connect(func(): 
		enemy_corpses_collected[new_enemy.resource] += 1
		enemy_corpse_amount_updated.emit(enemy_corpses_collected)
	)
	# probably make a better place to add this as a child
	add_child(new_enemy)

func _on_wave_spawner_wave_ended() -> void:
	start_wave_button.show()
	scrapyard.show()

func _on_wave_spawner_wave_started() -> void:
	start_wave_button.hide()
	scrapyard.hide()

func _on_scrapyard_mech_built(mech_resource: MechResource) -> void:
	var m: FrogMech = player_mech_scene.instantiate()
	m.resource = mech_resource
	$World.add_child(m)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter_scrapyard"):
		if scrapyard.visible:
			exit_scrapyard()
		else:
			enter_scrapyard()
