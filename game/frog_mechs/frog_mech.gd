extends DragableRgidBody

class_name FrogMech

## This is the mini frog AI
## It should patrol around the point it is connected to

var direction := 1.
# Set to true by parent when it is connected
var connected = false

signal create_attack(bullet_spawner: BulletSpawner)
# Signal emitted when a commander sees an enemy. Unused by other ranks.
signal enemy_detected(enemy: Enemy)

var cooldown = 0.0

@export var resource: MechResource = null

@onready var game: Game = get_tree().get_first_node_in_group("game")
@onready var wire_recpetacle: WireReceptacle = %WireReceptacle
@onready var cooldown_bar: ProgressBar = %Cooldown

func _ready() -> void:
	if resource.mech_class == MechResource.MechClass.Commander:
		cooldown_bar.show()
	($RankLabel as Label).text = resource.name
	($TakeDamage as TakeDamage).parent_resource = resource

	super._ready()

func get_connected_commander():
	var w := wire_recpetacle.get_wires()
	if len(w) > 0:
		var other_end = w[0].get_other_end(wire_recpetacle)
		if other_end:
			return other_end.get_parent()
		return null
	return null

func get_connected_frogs():
	var wires := wire_recpetacle.get_wires()
	var frogs = []
	for w in wires:
		var other_end = w.get_other_end(wire_recpetacle)
		if other_end != null:
			frogs.push_back(other_end.get_parent())
	return frogs

func _process(delta: float) -> void:
	if resource.mech_class == MechResource.MechClass.Commander:
		cooldown_bar.value = cooldown / get_total_cooldown()

	if resource.detection_software != null:
		var enemies: Array[Enemy] = []
		for e: Enemy in get_tree().get_nodes_in_group("enemy"):
			enemies.push_back(e)
		if len(enemies) > 0:
			enemies = resource.detection_software.detect(global_position, enemies)
			if len(enemies) > 0:
				# Only increment delta when enemy is in range
				cooldown += delta
				if cooldown > get_total_cooldown():
					enemy_detected.emit(enemies.pick_random())
					cooldown = 0
			else:
				cooldown = 0
		else:
			cooldown = 0

	super._process(delta)

func get_total_cooldown():
	var total = 0.0
	for c in get_connected_frogs().map(func(x): return x.resource.cooldown_ratio):
		total += c
	return total * .25

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	# Do not do anything when being dragged
	if dragging:
		return

	# AI
	if get_connected_commander() != null:
		ai()

func ai():
	if resource.mech_class == MechResource.MechClass.Recruit:
		direction = -sign(global_position.x - get_connected_commander().global_position.x)
	if on_floor:
		apply_central_impulse(Vector2(direction * 200., -200.))
		direction *= -1

func get_receptacle() -> WireReceptacle:
	return wire_recpetacle

func try_attack(enemy: Enemy):
	var b := BulletSpawner.new()
	resource.effect.apply(b)
	b.target_enemy = enemy
	create_attack.emit(b)
