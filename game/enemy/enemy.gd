extends CharacterBody2D

class_name Enemy

@export var health = 10
@export var value = 10
@export var movement_speed = 150
@export var standing_range = 100
@export var attack_interval = 0.5
@export var resource: EnemyResource

@onready var scrap = preload("res://game/enemy/scrap.tscn")

var target: Node = null
var attack_cooldown: float = 0

signal on_death

func _ready() -> void:
	health = resource.health
	($TakeDamage as TakeDamage).health = health

func _process(delta: float) -> void:
	health = ($TakeDamage as TakeDamage).health
	($Health as Label).text = str(health)
	
	attack_cooldown -= delta

	# Gravity
	velocity.y += 9.81

	pathfind()


func pathfind():
	# Walk torwards the center of the map, that is where the home base is
	var _direction = -sign(position.x)
	if target and attack_cooldown <= 0:
		attack()
	else:
		velocity.x = -sign(position.x) * movement_speed

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
			var _piece = scrap.instantiate(amount)
			tracker -= amount
		on_death.emit()
		queue_free()

func attack():
	attack_cooldown += attack_interval

func set_target(player: Node):
	target = player
