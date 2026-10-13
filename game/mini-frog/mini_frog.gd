extends DragableCharacterBody

class_name MiniFrog

## This is the mini frog AI
## It should patrol around the point it is connected to

var direction := 1.
# Set to true by parent when it is connected
var connected = false

signal create_attack(bullet_spawner: BulletSpawner)

var cooldown = 0.0

@onready var game: Game = get_tree().get_first_node_in_group("game")
@onready var wire_recpetacle: WireReceptacle = %WireReceptacle

func get_connected_tower():
	var w := wire_recpetacle.get_wires()
	if len(w) > 0:
		var other_end = w[0].get_other_end(wire_recpetacle)
		if other_end:
			return other_end.get_parent()
		return null
	return null

func _process(delta: float) -> void:
	if game:
		if game.in_command_mode:
			disable_dragging = false
		else:
			disable_dragging = true

	cooldown += delta
	super._process(delta)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	# Do not do anything when being dragged
	if dragging:
		return
	# Add gravity
	velocity.y += 9.81

	# AI
	if connected:
		ai()
		move_and_slide()

func ai():
	if is_on_floor():
		velocity = Vector2(direction * 200., -200.)
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
