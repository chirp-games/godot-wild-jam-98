extends CharacterBody2D

class_name Enemy

var health
var value
var speed: float = 500
var attack_interval
var grounded
@export var resource: EnemyResource

@onready var scrap = preload("res://game/enemy/scrap.tscn")

var target: Node2D = null
var attack_cooldown: float = 0

signal on_death

func _ready() -> void:
	($TakeDamage as TakeDamage).parent_resource = resource
	($TakeDamage as TakeDamage).health = health
	health = resource.health
	value = resource.scrap_value
	speed = resource.movement_speed
	attack_interval = resource.attack_interval
	grounded = resource.grounded

func _process(delta: float) -> void:
	health = ($TakeDamage as TakeDamage).health
	($Health as Label).text = str(health)
	
	# gravity
	velocity.y += 9.81
	
	attack_cooldown -= delta

	pathfind(delta)


func pathfind(_delta: float):
	# Walk torwards the center of the map, that is where the home base is
	speed = 5
	var x_vel: float = -sign(position.x) * speed
	velocity += Vector2(x_vel, 0)
	move_and_slide()

func apply_central_impulse(impulse):
	velocity += impulse

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

func entity_detected(body: Node2D):
	body

func set_target(player: Node):
	target = player


func _on_take_damage_death() -> void:
	on_death.emit()
	# This is where a death animation can go
	queue_free()


func _on_aggro_detected(area: Area2D) -> void:
	if not area is TakeDamage:
		return
	
	if (area as TakeDamage).damaged_by_group == "enemy_attack":
		target_select(area)

func target_select(area: Area2D) -> void:
	if !target:
		target = area
