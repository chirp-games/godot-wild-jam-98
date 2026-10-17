extends Node

var VFX_FIREBALL_IMPACT = preload("res://fx/fireball-impact.tscn")
var VFX_METAL_SPARK = preload("res://fx/metal-spark.tscn")

func create_vfx(fx: PackedScene, transform: Transform2D):
	var fx_scene: AnimatedSprite2D = fx.instantiate()
	add_child(fx_scene)
	fx_scene.transform = transform
	fx_scene.rotation += PI
	fx_scene.animation_finished.connect(func(): fx_scene.queue_free())

func create_vfx_with_node2d_parent():
	pass
