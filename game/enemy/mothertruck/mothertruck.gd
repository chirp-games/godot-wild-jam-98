extends Enemy

var cargo = 7
var rat = preload("res://game/enemy/mothertruck/rat.tscn")

var cooldown = 0.
const DELAY = .6

func _process(delta: float) -> void:
	cooldown -= delta
	
	if cargo > 0:
		super(delta)
	else:
		velocity.x = sign(position.x) * 40

func attack():
	if cooldown <= 0:
		var spawn = rat.instantiate()
		spawn.position = position
		spawn.set_target(target)
		cooldown = DELAY
