extends CharacterBody2D

@onready var EXPLOSION = preload("res://game/enemy/explosion.tscn")


func _physics_process(delta: float) -> void:
	if is_on_floor():
		boom()
	velocity.y += get_gravity().y * delta
	move_and_slide()

func hit(area: Area2D) -> void:
	if not area is TakeDamage:
		return
	
	if (area as TakeDamage).damaged_by_group == "enemy_attack":
		boom()

func boom() -> void:
	var explosion: Explosion = EXPLOSION.instantiate()
	explosion.setup(0.12, 50)
	explosion.global_position = global_position
	Vfx.create_vfx(Vfx.VFX_EMBER_FOUNTAIN, global_position + Vector2(0, 25))
	get_parent().add_child(explosion)
	queue_free()
