extends CharacterBody2D

class_name Enemy

@export var health = 10
@export var value = 10
@export var standing_range = 100

var target: Node = null

func _process(delta: float) -> void:
	($Health as Label).text = str(health)

	var player: Node = get_tree().get_nodes_in_group("player").get(0)

	if player:
		pathfind(player)


func pathfind(player):
	var direction = 0
	if abs(player.position.x - position.x) > standing_range:
		if player.position.x < position.x:
			direction = -1
		else:
			direction = 1
	else:
		attack()
	velocity.x = direction * 20

	move_and_slide()
	

func damage(d: int):
	health -= d
	if health <= 0:
		queue_free()

func attack():
	pass

func set_target(player: Node):
	target = player
