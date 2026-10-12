extends CharacterBody2D

class_name MiniFrog

## This is the mini frog AI
## It should patrol around the point it is connected to

var direction := 1.
var just_connected := true

signal create_attack(bullet_spawner: BulletSpawner)

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
	var tower = get_connected_tower()
	if tower and just_connected:
		global_position = tower.global_position
		just_connected = false
	if not tower:
		just_connected = true

func _physics_process(delta: float) -> void:
	# Add gravity
	velocity.y += 9.81
	# AI
	if is_on_floor():
		velocity = Vector2(direction * 200., -200.)
		direction *= -1
	
	move_and_slide()

func try_attack(enemy: Enemy):
	var b = BulletSpawner.new()
	b.target_enemy = enemy
	create_attack.emit(b)
