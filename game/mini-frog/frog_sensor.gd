extends Node2D

class_name Tower

signal enemy_detected(enemy: Enemy)

const MINI_FROG_MECH = preload("res://game/mini-frog/mini-frog.tscn")
const WIRE_SCENE = preload("res://game/MechBuilder/Wire.tscn")

@onready var enemy_detection_area: Area2D = %EnemyDetectionArea
@onready var wire_receptacle: WireReceptacle = %WireReceptacle

func _process(_delta: float) -> void:
	for body in enemy_detection_area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			enemy_detected.emit(body)

func get_connected_frogs() -> Array[MiniFrog]:
	var frogs: Array[MiniFrog] = []
	for wire: Wire in wire_receptacle.get_wires():
		var other_end = wire.get_other_end(wire_receptacle)
		if other_end:
			frogs.push_back(other_end.get_parent())
	return frogs
