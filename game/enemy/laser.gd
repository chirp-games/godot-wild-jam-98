extends DealDamage
class_name Laser

var lived = false

# Called when the node enters the scene tree for the first time.
func setup(damage: int, ends: Array[Vector2]) -> void:
	var hitline: SegmentShape2D = (%Beam as CollisionShape2D).shape
	var line: Line2D = %Line
	hitline.a = ends[1]
	hitline.b = ends[2]
	line.points = ends
	
	base_damage = damage

func _process(delta: float) -> void:
	if lived:
		queue_free()
	lived = true
	
	delta
