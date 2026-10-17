@tool
extends Container

func get_pvector_extents(p:PackedVector2Array)->Vector4: 
	var minX:float = p[0].x
	var maxX:float = p[0].x 
	var minY:float = p[0].y 
	var maxY:float = p[0].y
	for v in p: 
		if v.x < minX: 
			minX = v.x
		if v.x > maxX: 
			maxX = v.x
		if v.y < minY: 
			minY = v.y
		if v.y > maxY: 
			maxY = v.y
	if minY < 0:
		minY = 0
	return Vector4(minX, minY, maxX, maxY)

func get_polygon_size(p:PackedVector2Array)->Vector2: 
	var v:Vector4 = get_pvector_extents(p)
	var r:Rect2 = Rect2(v.x, v.y, abs(v.z - v.x), abs(v.w - v.y))
	return r.size

func _ready() -> void:
	custom_minimum_size = get_polygon_size($StaticBody2D.get_child(0).polygon)
