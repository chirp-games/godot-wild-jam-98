extends Node2D

const wire_scene = preload("res://game/MechBuilder/Wire.tscn")

signal create_projectile(chain: Array, target: Enemy)

var currently_building_wire: Wire

func find_wire_receptacles():
	return get_tree().get_nodes_in_group("wire_receptacle")

func find_wires():
	return get_tree().get_nodes_in_group("wire")

func find_mech_pieces() -> Array[MechPiece]:
	return get_tree().get_nodes_in_group("mech_piece") as Array[MechPiece]

func find_energy_ports() -> Array[WireReceptacle]:
	return get_tree().get_nodes_in_group("energy_port") as Array[WireReceptacle]


func _ready() -> void:
	for receptacle: WireReceptacle in find_wire_receptacles():
		receptacle.wire_started.connect(func(): _wire_started(receptacle))

func _process(delta: float) -> void:
	var chains = []
	
	for p in find_energy_ports():
		var c = find_chain(p)
		if len(c) >= 1:
			chains.push_back(c)
	
	for chain in chains:
		var active = false
		var previous_was_charged = true
		for i in range(len(chain)):
			var piece = chain[i]
			if i == 0 and piece.detected_target:
				active = true
			if piece.cooldown_charge >= piece.resource.cooldown:
				continue
			if active and previous_was_charged:
				piece.cooldown_charge += delta
				previous_was_charged = false
			else:
				piece.cooldown_charge = 0

		if previous_was_charged == true and active:
			# If everything was charged, fire!
			create_projectile.emit(chain, chain[0].detected_target)
			for p in chain:
				p.cooldown_charge = 0


func _wire_started(receptacle: WireReceptacle):
	if currently_building_wire:
		return
	var w: Wire = wire_scene.instantiate()
	%Wires.add_child(w)
	w.a = receptacle
	currently_building_wire = w

## Starting at a sensor, find all things connected to it. 
## Connects from BLUE to RED. Cannot go backwards from RED to BLUE.
func find_chain(blue_receptacle: WireReceptacle) -> Array[MechPiece]:
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
			var connected_to_mech_piece = other_side.get_mech_piece()
			return find_chain(connected_to_mech_piece.get_blue_receptacle()) + [connected_to_mech_piece]

	return []

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
