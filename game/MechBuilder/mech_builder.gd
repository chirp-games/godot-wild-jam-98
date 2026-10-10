extends Node2D

const wire_scene = preload("res://game/MechBuilder/Wire.tscn")

var currently_building_wire: Wire

func _ready() -> void:
	for receptacle: WireReceptacle in get_tree().get_nodes_in_group("wire_receptacle"):
		receptacle.wire_started.connect(func(): _wire_started(receptacle))
		receptacle.trigger.connect(func(): _trigger(receptacle))

func _wire_started(receptacle: WireReceptacle):
	print("here")
	if currently_building_wire:
		return
	var w: Wire = wire_scene.instantiate()
	%Wires.add_child(w)
	w.a = receptacle
	currently_building_wire = w

func _trigger(receptacle: WireReceptacle):
	if receptacle.type == WireReceptacle.Type.Female:
		for w: Wire in get_tree().get_nodes_in_group("wire"):
			if w.a == receptacle:
				pass
			if w.b == receptacle:
				pass

func try_placing_wire():
	if not currently_building_wire:
		return
	for receptacle: WireReceptacle in get_tree().get_nodes_in_group("wire_receptacle"):
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
