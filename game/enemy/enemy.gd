extends CharacterBody2D

class_name Enemy

@export var health = 10

func _process(delta: float) -> void:
	($Health as Label).text = str(health)

	var player: Node = get_tree().get_nodes_in_group("player").get(0)

	if player:
		pathfind(player)


func pathfind(player):
	var direction = 0
	if player.position.x < position.x:
		direction = -1
	else:
		direction = 1
	velocity.x = direction * 20

	move_and_slide()
	

func damage(d: int):
	health -= d
	if health <= 0:
		queue_free()
