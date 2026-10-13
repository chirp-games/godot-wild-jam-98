extends CharacterBody2D

class_name Enemy

@export var health = 10

func _process(delta: float) -> void:
	($Health as Label).text = str(health)

	# Gravity
	velocity.y += 9.81

	var player: Node = get_tree().get_first_node_in_group("player")

	if player:
		pathfind(player)


func pathfind(player):
	# Walk torwards the center of the map, that is where the home base is
	var direction = -sign(position.x)
	velocity.x = direction * 50

	move_and_slide()
	

func damage(d: int):
	health -= d
	if health <= 0:
		queue_free()
