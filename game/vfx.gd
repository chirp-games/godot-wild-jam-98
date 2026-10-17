extends Node

var VFX_FIREBALL_IMPACT = preload("res://fx/fireball-impact.tscn")
var VFX_METAL_SPARK = preload("res://fx/metal-spark.tscn")

func create_vfx_at_node2D(fx: PackedScene, at: Node2D):
	var fx_scene: AnimatedSprite2D = fx.instantiate()
	add_child(fx_scene)
	fx_scene.global_position = at.global_position
	fx_scene.rotation = at.rotation
	fx_scene.animation_finished.connect(func(): fx_scene.queue_free())

func create_vfx_with_node2d_parent():
	pass
