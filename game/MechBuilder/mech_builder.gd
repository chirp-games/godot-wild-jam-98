extends Node2D

const wire_scene = preload("res://game/MechBuilder/Wire.tscn")

var currently_building_wire: Wire

func find_wire_receptacles():
	return get_tree().get_nodes_in_group("wire_receptacle")

func find_wires():
	return get_tree().get_nodes_in_group("wire")


func _ready() -> void:
	for receptacle: WireReceptacle in find_wire_receptacles():
		receptacle.wire_started.connect(func(): _wire_started(receptacle))

	for piece: MechPiece in get_tree().get_nodes_in_group("mech_piece"):
		piece.activate.connect(func(): _trigger(piece))

func _wire_started(receptacle: WireReceptacle):
	if currently_building_wire:
		return
	var w: Wire = wire_scene.instantiate()
	%Wires.add_child(w)
	w.a = receptacle
	currently_building_wire = w

func _trigger(receptacle: MechPiece):
	print("trigger")
	print(find_connected_line(receptacle))

## Starting at a sensor, find all things connected to it. 
## Connects from BLUE to RED. Cannot go backwards from RED to BLUE.
func find_connected_line(mech_piece: MechPiece) -> Array[MechPiece]:
	var blue_receptacle = mech_piece.get_blue_receptacle()
	if not blue_receptacle:
		return [mech_piece]
	
	for w in find_wires():
		# If we connect
		var other_side: WireReceptacle
		if w.a == blue_receptacle:
			other_side = w.b
		if w.b == blue_receptacle:
			other_side = w.a

		# We connected to something
		# Should get here for any connected wire
		if other_side:
			var connected_to_mech_piece := other_side.get_mech_piece()
			return [mech_piece] + find_connected_line(connected_to_mech_piece)

	return [mech_piece]

func try_placing_wire():
	if not currently_building_wire:
		return
	for receptacle: WireReceptacle in find_wire_receptacles():
		if currently_building_wire.a == receptacle:
			continue
		if receptacle.get_global_rect().has_point(get_global_mouse_position()) and receptacle.type != currently_building_wire.a.type:
			currently_building_wire.b = receptacle
			currently_building_wire = null
			return
	currently_building_wire.queue_free()
	currently_building_wire = null

func _input(event: InputEvent) -> void:
	if event.is_action_released("right_click", true):
		try_placing_wire()
