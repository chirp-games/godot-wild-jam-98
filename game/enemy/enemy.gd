extends CharacterBody2D

class_name Enemy

@export var health = 10
@export var value = 10
@export var standing_range = 100
@export var resource: EnemyResource

@onready var scrap = preload("res://game/enemy/scrap.tscn")

var target: Node = null

signal on_death

func _ready() -> void:
	health = resource.health

func _process(_delta: float) -> void:
	($Health as Label).text = str(health)

	# Gravity
	velocity.y += 9.81

	var player: Node = get_tree().get_first_node_in_group("player")

	if player:
		pathfind(player)


func pathfind(_player):
	# Walk torwards the center of the map, that is where the home base is
	var direction = -sign(position.x)
	velocity.x = direction * 50

	move_and_slide()

func hit_command_center():
	queue_free()

func damage(d: int):
	health -= d
	if health <= 0:
		var tracker = value
		while tracker > 0:
			var amount: int = randi_range(2, 10) + randi_range(2, 10)
			if amount > tracker:
				amount = tracker
			var piece = scrap.instantiate(amount)
			tracker -= amount
		on_death.emit()
		queue_free()

func attack():
	pass

func set_target(player: Node):
	target = player
