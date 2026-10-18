extends CharacterBody2D

class_name Enemy

var health
var value
var speed: float = 500
var attack_interval
var grounded

@export var resource: EnemyResource
@onready var scrap = preload("res://game/enemy/scrap.tscn")
@onready var parachute: Sprite2D = %Parachute
@onready var stun_timer: Timer = %StunTimer
@onready var stun_label: Label = %Stunned
@onready var on_hit_animation: AnimationPlayer =  %OnHitAnimation
@onready var death_animation: AnimationPlayer =  %DeathAnimation

var target: Node2D = null
var has_target: bool = false
var attack_cooldown: float = 0

## Summon reinforcements for a given wave
signal summon_reinforcements
signal on_death

func _ready() -> void:
	health = resource.health
	if not resource.has_parachute:
		parachute.hide()
	($TakeDamage as TakeDamage).parent_resource = resource
	($TakeDamage as TakeDamage).max_health = health
	($TakeDamage as TakeDamage).health = health
	value = resource.scrap_value
	speed = resource.movement_speed
	attack_interval = resource.attack_interval
	grounded = resource.grounded

func _process(delta: float) -> void:
	health = ($TakeDamage as TakeDamage).health
	($Health as Label).text = str(health)

func _physics_process(delta: float) -> void:
	if grounded:
		# gravity
		if not parachute.visible:
			velocity.y += 9.81
		else:
			# enemies with a parachute should fall slower
			velocity.y += 4.0
	
	if is_stunned():
		stun_label.show()
	else:
		stun_label.hide()
	
	if not is_stunned() and target:
		attack_cooldown -= delta
	
	if parachute.visible and is_on_floor():
		parachute.hide()
	
	if not $AggroDetection.monitoring:
		$AggroDetection.monitoring = true
	
	if not target and has_target:
		has_target = false
		$AggroDetection.monitoring = false
	
	if not is_stunned() and $AggroDetection.monitoring:
		pathfind(delta)
	move_and_slide()

func pathfind(_delta: float):
	if not target:
		if not grounded or not parachute.visible:
			velocity.x = -sign(global_position.x) * speed
	elif target.global_position.distance_to($AggroDetection.global_position) > $AggroDetection/Range.shape.radius + 100:
		velocity.x = -sign(global_position.x - target.global_position.x) * speed
	else:
		velocity.x = 0
		if attack_cooldown <= 0:
			attack()

func apply_central_impulse(impulse):
	velocity += impulse

func hit_command_center():
	queue_free()

func attack():
	attack_cooldown += attack_interval

func set_target(player: Node):
	target = player

func _on_take_damage_death() -> void:
	on_death.emit()
	# This is where a death animation can go
	death_animation.play("death")
	await death_animation.animation_finished
	queue_free()

func _on_aggro_detected(area: Area2D) -> void:
	if not area is TakeDamage:
		return
	
	if (area as TakeDamage).damaged_by_group == "enemy_attack":
		target_select(area)

func is_stunned():
	return not stun_timer.is_stopped()

# Called when the player jumps near this enemy
func stun():
	stun_timer.start()

func target_select(area: Area2D) -> void:
	if !target:
		target = area
		has_target = true

func _on_take_damage_damage_taken(_amount: int) -> void:
	on_hit_animation.play("hit")
	on_hit_animation.reset_section()

func disable_parachute() -> void:
	%Parachute.visible = false
