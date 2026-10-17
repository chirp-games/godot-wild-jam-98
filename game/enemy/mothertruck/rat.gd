extends Enemy

@onready var EXPLOSION = preload("res://game/enemy/explosion.tscn")

func attack():
	var explosion: Explosion = EXPLOSION.instantiate()
	explosion.setup(0.15, 50)
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	queue_free()
