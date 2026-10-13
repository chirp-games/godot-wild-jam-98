extends DragableTextureRect

class_name Tower

signal enemy_detected(enemy: Enemy)

const MINI_FROG_MECH = preload("res://game/mini-frog/mini-frog.tscn")
const WIRE_SCENE = preload("res://game/MechBuilder/Wire.tscn")

@onready var game: Game = get_tree().get_first_node_in_group("game")
@onready var enemy_detection_area: Area2D = %EnemyDetectionArea
@onready var wire_receptacle: WireReceptacle = %WireReceptacle

func _ready() -> void:
	grid_size = Vector2(64, 64)
	super._ready()

func _process(_delta: float) -> void:
	if game:
		if game.in_command_mode:
			disable_dragging = false
		else:
			disable_dragging = true
	for body in enemy_detection_area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			enemy_detected.emit(body)
	super._process(_delta)

func get_connected_frogs() -> Array[MiniFrog]:
	var frogs: Array[MiniFrog] = []
	for wire: Wire in wire_receptacle.get_wires():
		var other_end = wire.get_other_end(wire_receptacle)
		if other_end:
			frogs.push_back(other_end.get_parent())
	return frogs
