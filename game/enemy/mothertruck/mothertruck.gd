extends Enemy

var cargo = 7
var rat = preload("res://game/enemy/mothertruck/rat.tscn")

func _physics_process(delta: float) -> void:
	if cargo > 0:
		super(delta)
	else:
		velocity.x = sign(position.x) * speed

func attack():
	var spawn: Enemy = rat.instantiate()
	spawn.position = position
	spawn.set_target(target)
	super.attack()
