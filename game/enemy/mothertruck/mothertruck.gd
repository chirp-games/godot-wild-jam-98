extends Enemy

class_name KDDV

var cargo = 8
var rat = preload("res://game/enemy/mothertruck/rat.tscn")

func _physics_process(delta: float) -> void:
	if cargo > 0:
		super(delta)
	else:
		velocity.x = sign(global_position.x) * speed
		move_and_slide()

func attack():
	var spawn: Enemy = rat.instantiate()
	spawn.global_position = global_position
	spawn.disable_parachute()
	get_parent().add_child(spawn)
	cargo -= 1
	super.attack()
