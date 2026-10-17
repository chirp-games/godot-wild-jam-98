extends Enemy

@onready var EXPLOSION = preload("res://game/enemy/explosion.tscn")

var side: int
var θv: float
var ω = PI
var locked = false

func pathfind(delta: float):
	if not target:
		super(delta)
	else:
		var θ: float = velocity.angle_to(global_position.direction_to(target.global_position))
		
		if !locked and target and abs(θ) >= PI/16:
			locked = true
		
		if locked:
			var Δθ: float = ω * delta * sign(θ) * min(1, 300 / global_position.distance_to(target.global_position))
			print([θ, rotation, Δθ])
			self.rotate(Δθ)
			velocity = velocity.length() * Vector2(cos(θv+rotation), sin(θv+rotation))
		else:
			velocity = Vector2.LEFT * sign(global_position.x) * speed

func _physics_process(delta: float):
	if not θv:
		side = sign(-global_position.x)
		θv = PI/2 - PI/2*side
	if is_on_floor():
		attack()
	super(delta)

func attack():
	var explosion: Explosion = EXPLOSION.instantiate()
	explosion.setup(0.5, 300)
	queue_free()
