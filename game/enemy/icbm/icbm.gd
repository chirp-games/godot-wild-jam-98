extends Enemy

@onready var EXPLOSION = preload("res://game/enemy/explosion.tscn")

var last_pos

const ω = PI/16

func _ready():
	super()
	last_pos = Vector2(0,0) # Temporary line for testing

func _physics_process(delta: float) -> void:
	var head = $Warhead.global_position - global_position
	var θ = head.angle_to(last_pos - global_position)
	
	var Δθ: float = ω * delta * sign(θ)
	self.rotate(Δθ)
	
	if target:
		attack()
	
	velocity = Vector2.from_angle(rotation) * speed
	move_and_slide()

func attack():
	var explosion: Explosion = EXPLOSION.instantiate()
	explosion.setup(1., 750)
	explosion.global_position = $Warhead.global_position
	Vfx.create_vfx(Vfx.VFX_EMBER_FOUNTAIN, $Warhead.global_position + Vector2(0, 45))
	get_parent().add_child(explosion)
	queue_free()
