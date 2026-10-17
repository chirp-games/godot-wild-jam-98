extends CharacterBody2D

@onready var BOMBLET = preload("res://game/enemy/ammunition/artillery/155mm/bomblet.tscn")

func _physics_process(delta: float) -> void:
	if ($Fuze as Marker2D).global_position.y >= -1200 and velocity.y > 0:
		for i in 20:
			var bomblet: CharacterBody2D = BOMBLET.instantiate()
			bomblet.global_position = ($Fuze as Marker2D).global_position
			bomblet.velocity = velocity + randf_range(0, 720) * Vector2.from_angle(randf_range(-PI,PI)) * Vector2(1,0.5)
			get_parent().add_child(bomblet)
		queue_free()
	
	velocity.y += get_gravity().y * delta
	self.rotation = atan(velocity.y / velocity.x) # Idk which way this faces so I'll leave the correction for later.
	move_and_slide()
