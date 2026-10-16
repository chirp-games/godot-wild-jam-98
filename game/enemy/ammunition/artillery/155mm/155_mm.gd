extends CharacterBody2D

@onready var BOMBLET = preload("res://game/enemy/ammunition/artillery/155mm/bomblet.tscn")

func _physics_process(delta: float) -> void:
	if ($Fuze as Marker2D).global_position.y >= -250 and velocity.y > 0:
		for i in 15:
			var bomblet: CharacterBody2D = BOMBLET.instantiate()
			bomblet.global_position = ($Fuze as Marker2D).global_position
			bomblet.velocity = velocity + Vector2(randf_range(-500,500),0)
	
	velocity.y += get_gravity().y * delta
	self.rotation = atan(velocity.y / velocity.x) # Idk which way this faces so I'll leave the correction for later.
	move_and_slide()
