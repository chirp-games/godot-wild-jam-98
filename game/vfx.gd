extends Node

var VFX_FIREBALL_IMPACT = preload("res://fx/fireball-impact.tscn")
var VFX_METAL_SPARK = preload("res://fx/metal-spark.tscn")
var VFX_STOMP_RING = preload("res://fx/stomp-ring.tscn")
var VFX_EMBER_FOUNTAIN = preload("res://fx/ember-fountain.tscn")
var VFX_ICBM_IMPACT = preload("res://fx/icbm-impact.tscn")
var VFX_SHAHED_IMPACT = preload("res://fx/shahed-impact.tscn")
var VFX_PRESSURE_RING = preload("res://fx/pressure-ring.tscn")

func create_vfx_at_node2D(fx: PackedScene, at: Node2D):
	create_vfx(fx, at.global_position, at.global_rotation)

func create_vfx(fx: PackedScene, position: Vector2, rotation: float = 0.0):
	var fx_scene: AnimatedSprite2D = fx.instantiate()
	add_child(fx_scene)
	fx_scene.global_position = position
	fx_scene.global_rotation = rotation
	fx_scene.animation_finished.connect(func(): fx_scene.queue_free())

func create_vfx_with_node2d_parent():
	pass
