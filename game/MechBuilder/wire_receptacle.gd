extends TextureRect

class_name WireReceptacle

## Emitted when the player clicks to make a wire.
signal wire_started
signal wire_ended

## When the mech piece needs to send a signal.
## Should only be activated by male ends.
signal trigger

enum Type {
	Red,
	Blue,
}
@export var type: Type = Type.Red

## Return the mech piece this wire receptacle is attached to
func get_mech_piece() -> MechPiece:
	if get_parent() is MechPiece:
		return get_parent()
	return null

func get_wires() -> Array[Wire]:
	var wires: Array[Wire] = []
	for wire: Wire in get_tree().get_nodes_in_group("wire"):
		if wire.a == self or wire.b == self:
			wires.push_back(wire)
	return wires

func _ready() -> void:
	if type == Type.Red:
		self_modulate = Color(0.945, 0.0, 0.0, 1.0)
	if type == Type.Blue:
		self_modulate = Color(0.276, 0.476, 0.804, 1.0)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		trigger.emit()
	if event.is_action_pressed("right_click"):
		wire_started.emit()
	if event.is_action_released("right_click"):
		wire_ended.emit()
