@tool

extends Container
class_name ScrapPit

signal remove_enemy(enemy: EnemyResource)

@onready var scrap_enemy_corpse: InstancePlaceholder = %ScrapEnemyCorpse

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
	return Vector4(minX, minY, maxX, maxY)

func get_polygon_size(p:PackedVector2Array)->Vector2: 
	var v:Vector4 = get_pvector_extents(p)
	var r:Rect2 = Rect2(v.x, v.y, abs(v.z - v.x), abs(v.w - v.y))
	return r.size

func add_enemy(enemy: EnemyResource):
	var corpse: ScrapEnemyCorpse = scrap_enemy_corpse.create_instance()
	corpse.set_enemy(enemy)
	corpse.on_click.connect(
		func():
			remove_enemy.emit(enemy)
			corpse.queue_free()
	)
	corpse.global_position = %AddCorpse.global_position
	corpse.global_position.x += randf_range(-30, 30)

func _ready() -> void:
	custom_minimum_size = get_polygon_size($StaticBody2D.get_child(0).polygon)
