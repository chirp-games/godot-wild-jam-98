extends Enemy

@onready var EXPLOSION = preload("res://game/enemy/explosion.tscn")

var ω = PI
var locked = false

func pathfind(delta: float):
	var θ: float = Vector2(-cos(rotation) * signf(global_position.x),-sin(rotation)).angle_to(target.global_position.direction_to(global_position))
	if !locked and target and θ <= PI/24:
		locked = true
	
	if locked:
		var Δθ: float = ω * delta
		if abs(Δθ) > θ:
			Δθ = θ
		else:
			Δθ *= sign(θ)
		
		self.rotate(Δθ)
		velocity = velocity.length() * Vector2(-cos(rotation) * signf(global_position.x), -sin(rotation))
	else:
		velocity = Vector2.LEFT * -sign(global_position.x) * speed
	
	move_and_slide()

func _physics_process(delta: float):
	if is_on_floor():
		attack()
	delta

func attack():
	var explosion: Explosion = EXPLOSION.instantiate()
	explosion.setup(0.5, 300)
