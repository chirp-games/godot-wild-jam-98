extends Node2D

const wire_scene = preload("res://mech_builder_test/Wire.tscn")

var currently_building_wire: Wire

func _ready() -> void:
	for piece: MechPiece in get_tree().get_nodes_in_group("mech_piece"):
		piece.wire_started.connect(func(): _wire_started(piece))
		piece.delete_wire.connect(func(): _delete_wires(piece))

func _wire_started(piece: MechPiece):
	if currently_building_wire:
		return
	var w: Wire = wire_scene.instantiate()
	%Wires.add_child(w)
	w.a = piece
	currently_building_wire = w

func _delete_wires(piece):
	for w: Wire in get_tree().get_nodes_in_group("wire"):
		if w.a == piece or w.b == piece:
			w.queue_free()

func try_placing_wire():
	if not currently_building_wire:
		return
	for piece: MechPiece in get_tree().get_nodes_in_group("mech_piece"):
		if currently_building_wire.a == piece:
			continue
		if piece.get_global_rect().has_point(get_global_mouse_position()):
			currently_building_wire.b = piece
			currently_building_wire = null
			return
	currently_building_wire.queue_free()
	currently_building_wire = null

func _input(event: InputEvent) -> void:
	if event.is_action_released("right_click", true):
		try_placing_wire()
