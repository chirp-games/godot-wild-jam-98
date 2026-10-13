extends DragableRgidBody

class_name MiniFrog

## This is the mini frog AI
## It should patrol around the point it is connected to

enum Rank {
	Recruit,
	Lieutenant,
	Commander,
}

var direction := 1.
# Set to true by parent when it is connected
var connected = false

signal create_attack(bullet_spawner: BulletSpawner)
# Signal emitted when a commander sees an enemy. Unused by other ranks.
signal enemy_detected(enemy: Enemy)

var cooldown = 0.0

@onready var game: Game = get_tree().get_first_node_in_group("game")
@onready var wire_recpetacle: WireReceptacle = %WireReceptacle
@onready var enemy_detection_radius: Area2D = %EnemyDetectionRadius

@export var rank: Rank

func _ready() -> void:
	var rank_text := ""
	if rank == Rank.Recruit:
		rank_text = "Recruit"
	if rank == Rank.Lieutenant:
		rank_text = "Lieutenant"
	if rank == Rank.Commander:
		rank_text = "Commander"
	($RankLabel as Label).text = rank_text
	
	if rank != Rank.Commander:
		enemy_detection_radius.hide()

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
	cooldown += delta

	if enemy_detection_radius.is_visible_in_tree():
		for body in enemy_detection_radius.get_overlapping_bodies():
			if body.is_in_group("enemy"):
				enemy_detected.emit(body)

	super._process(delta)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	# Add gravity
	velocity.y += 9.81
	
	# Do not do anything when being dragged
	if dragging:
		return

	# AI
	if connected:
		ai()

func ai():
	if rank == Rank.Recruit:
		direction = -sign(global_position.x - get_connected_commander().global_position.x)
	if on_floor:
		apply_central_impulse(Vector2(direction * 200., -200.))
		direction *= -1

func get_receptacle() -> WireReceptacle:
	return wire_recpetacle

func try_attack(enemy: Enemy):
	if cooldown < .5:
		return
	cooldown = 0.0
	var b = BulletSpawner.new()
	b.target_enemy = enemy
	create_attack.emit(b)
